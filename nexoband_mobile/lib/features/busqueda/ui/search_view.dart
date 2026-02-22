import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/service/search_service.dart';
import 'package:nexoband_mobile/features/busqueda/bloc/search_bloc.dart';
import 'package:nexoband_mobile/features/busqueda/ui/widget/search_band_card_widget.dart';
import 'package:nexoband_mobile/features/busqueda/ui/widget/search_musician_card_widget.dart';


class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  late final SearchBloc _searchBloc;
  Timer? _debounce; // para no llamar a la API en cada tecla

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(SearchService());
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _searchBloc.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Espera 400ms después de que el usuario deje de escribir
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.trim().isEmpty) {
        _searchBloc.add(LimpiarBusqueda());
      } else {
        _searchBloc.add(BuscarTodo(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Buscar',
              style: TextStyle(color: Colors.white)),
          centerTitle: false,
        ),
        body: Column(
          children: [
            // Buscador
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar músicos, bandas, instrumentos...',
                  hintStyle:
                      const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[900],
                  prefixIcon: const Icon(Icons.search,
                      color: Colors.white54),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white54),
                          onPressed: () {
                            _controller.clear();
                            _searchBloc.add(LimpiarBusqueda());
                            setState(() {});
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {}); // para mostrar/ocultar la X
                  _onSearchChanged(value);
                },
              ),
            ),
            const SizedBox(height: 8),
            // Resultados
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const Center(
                      child: Text(
                        'Busca músicos por nombre, instrumento o género...',
                        style: TextStyle(
                            color: Colors.white54, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is SearchCargando) {
                    return const Center(
                        child: CircularProgressIndicator());
                  } else if (state is SearchError) {
                    return Center(
                      child: Text(state.mensaje,
                          style: const TextStyle(color: Colors.red)),
                    );
                  } else if (state is SearchResultados) {
                    if (state.vacio) {
                      return Center(
                        child: Text(
                          'No se encontraron resultados para "${_controller.text}"',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    // Lista mezclada: primero usuarios, luego bandas
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      children: [
                        if (state.usuarios.isNotEmpty) ...[
                          const _SeccionHeader(titulo: 'Músicos'),
                          ...state.usuarios.map((u) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SearchMusicianCardWidget(
                                    usuario: u),
                              )),
                        ],
                        if (state.bandas.isNotEmpty) ...[
                          const _SeccionHeader(titulo: 'Bandas'),
                          ...state.bandas.map((b) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SearchBandCardWidget(banda: b),
                              )),
                        ],
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeccionHeader extends StatelessWidget {
  final String titulo;
  const _SeccionHeader({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
