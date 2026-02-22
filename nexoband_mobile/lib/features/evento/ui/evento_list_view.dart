import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/features/evento/bloc/evento_bloc.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/evento_card.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/map_icon_button.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/map_marker.dart';

class EventoListView extends StatefulWidget {
  const EventoListView({super.key});

  @override
  State<EventoListView> createState() => _EventoListViewState();
}

class _EventoListViewState extends State<EventoListView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _buscadorVisible = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<EventoResponse> _filtrar(List<EventoResponse> eventos) {
    if (_query.isEmpty) return eventos;
    final q = _query.toLowerCase();
    return eventos.where((e) =>
      e.nombre.toLowerCase().contains(q) ||
      e.lugar.toLowerCase().contains(q) ||
      (e.descripcion?.toLowerCase().contains(q) ?? false) ||
      e.bandas.any((b) => b.nombre.toLowerCase().contains(q))
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        elevation: 0,
        title: _buscadorVisible
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Buscar eventos...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => _query = value),
              )
            : const Text(
                'Eventos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _buscadorVisible ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _buscadorVisible = !_buscadorVisible;
                if (!_buscadorVisible) {
                  _query = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
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

            if (eventosFiltrados.isEmpty) {
              return Center(
                child: Text(
                  _query.isEmpty
                      ? 'No hay eventos próximos'
                      : 'No se encontraron eventos para "$_query"',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Column(
              children: [
                if (!_buscadorVisible)
                  Container(
                    margin: const EdgeInsets.all(16),
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Color(0xFF232323),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: GridMapPainter()),
                        ),
                        ...List.generate(
                          eventosFiltrados.length > 3 ? 3 : eventosFiltrados.length,
                          (i) => Positioned(
                            left: 60.0 + (i * 80),
                            top: 40.0 + (i * 30),
                            child: const MapMarker(),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 24,
                          child: Column(
                            children: [
                              MapIconButton(icon: Icons.add),
                              const SizedBox(height: 12),
                              MapIconButton(icon: Icons.search),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              '${eventosFiltrados.length} eventos próximos',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
    );
  }
}

class GridMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
