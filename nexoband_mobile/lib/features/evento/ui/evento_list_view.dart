import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/core/service/evento_service.dart';
import 'package:nexoband_mobile/features/evento/bloc/evento_bloc.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/evento_card.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/map_marker.dart';

class EventoListView extends StatefulWidget {
  const EventoListView({super.key});

  @override
  State<EventoListView> createState() => _EventoListViewState();
}

class _EventoListViewState extends State<EventoListView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  LatLng? _parseCoord(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split(',');
    if (parts.length < 2) return null;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return null;
    return LatLng(lat, lng);
  }

  LatLng _computeCenter(List<EventoResponse> eventos) {
    final coords = eventos
        .map((e) => _parseCoord(e.coordenadas))
        .whereType<LatLng>()
        .toList();
    if (coords.isEmpty) return const LatLng(40.4637, -3.7492);
    final lat =
        coords.map((c) => c.latitude).reduce((a, b) => a + b) / coords.length;
    final lng =
        coords.map((c) => c.longitude).reduce((a, b) => a + b) / coords.length;
    return LatLng(lat, lng);
  }

  List<EventoResponse> _filtrar(List<EventoResponse> eventos) {
    if (_query.isEmpty) return eventos;
    final q = _query.toLowerCase();
    return eventos
        .where(
          (e) =>
              e.nombre.toLowerCase().contains(q) ||
              e.lugar.toLowerCase().contains(q) ||
              (e.descripcion?.toLowerCase().contains(q) ?? false) ||
              e.bandas.any((b) => b.nombre.toLowerCase().contains(q)),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventoBloc(EventoService())..add(CargarEventos(soloProximos: true)),
      child: Scaffold(
        backgroundColor: const Color(0xFF181818),
        body: BlocBuilder<EventoBloc, EventoState>(
          builder: (context, state) {
            if (state is EventosCargando) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EventosCargaError) {
              return Center(
                child: Text(
                  state.mensaje,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is EventosCargados) {
              final eventosFiltrados = _filtrar(state.eventos);
              final markers = eventosFiltrados
                  .map((e) {
                    final coord = _parseCoord(e.coordenadas);
                    if (coord == null) return null;
                    return Marker(
                      point: coord,
                      width: 36,
                      height: 36,
                      child: const MapMarker(),
                    );
                  })
                  .whereType<Marker>()
                  .toList();
              final center = _computeCenter(eventosFiltrados);

              return Column(
                children: [
                  // ── Buscador ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => setState(() => _query = value),
                      decoration: InputDecoration(
                        hintText: 'Buscar evento...',
                        hintStyle:
                            const TextStyle(color: Color(0xFF888888)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF888888),
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xFF888888),
                                ),
                                onPressed: () => setState(() {
                                  _searchController.clear();
                                  _query = '';
                                }),
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFF232323),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  // ── Mapa real ────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: const Color(0xFF232323),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: FlutterMap(
                      key: ValueKey('map_${center.latitude}_${center.longitude}_${markers.length}'),
                      options: MapOptions(
                        initialCenter: center,
                        initialZoom: markers.isEmpty ? 5.5 : 7.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.nexoband.mobile',
                        ),
                        if (markers.isNotEmpty)
                          MarkerLayer(markers: markers),
                      ],
                    ),
                  ),
                  // ── Lista de eventos ─────────────────────────────
                  if (eventosFiltrados.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          _query.isEmpty
                              ? 'No hay eventos próximos'
                              : 'No se encontraron eventos para "$_query"',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: eventosFiltrados.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              EventoCard(evento: eventosFiltrados[index]),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}


