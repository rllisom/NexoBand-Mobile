import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';
import 'package:nexoband_mobile/features/publicaciones/bloc/publicacion_bloc.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/widget/publicacion_widget.dart';

class PublicacionView extends StatefulWidget {
  const PublicacionView({super.key});

  @override
  State<PublicacionView> createState() => _PublicacionViewState();
}

class _PublicacionViewState extends State<PublicacionView> {
  late PublicacionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PublicacionBloc(PublicacionService());
    _bloc.add(CargarFeed());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<PublicacionBloc, PublicacionState>(
        builder: (context, state) {

          // ── Cargando ──────────────────────────────────────
          if (state is FeedCargando) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFC7E39),
              ),
            );
          }

          // ── Feed vacío ────────────────────────────────────
          if (state is FeedVacio) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.music_off,
                    color: Colors.white38,
                    size: 72,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay publicaciones aún.\n¡Empieza a seguir artistas y bandas!',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // Botón para refrescar manualmente
                  GestureDetector(
                    onTap: () => _bloc.add(CargarFeed()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Refrescar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // ── Error ─────────────────────────────────────────
          if (state is FeedCargaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFF13B57),
                    size: 56,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.mensaje,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _bloc.add(CargarFeed()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF13B57), Color(0xFFFC7E39)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Reintentar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // ── Feed cargado ──────────────────────────────────
          if (state is FeedCargado) {
            return RefreshIndicator(
              color: const Color(0xFFFC7E39),
              backgroundColor: const Color(0xFF232120),
              onRefresh: () async => _bloc.add(CargarFeed()),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                itemCount: state.publicaciones.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: PublicacionWidget(
                      publicacion: state.publicaciones[index],
                    ),
                  );
                },
              ),
            );
          }

          // ── Estado inicial (nunca visible) ────────────────
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
