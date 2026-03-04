import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/model/item_feed.dart';
import 'package:nexoband_mobile/core/model/publicidad.dart';
import 'package:nexoband_mobile/core/service/comentario_service.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';
import 'package:nexoband_mobile/core/service/publicidad_service.dart';
import 'package:nexoband_mobile/features/publicaciones/bloc/publicacion_bloc.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/widget/publicacion_widget.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/widget/publicidad_widget.dart';

class PublicacionView extends StatefulWidget {
  const PublicacionView({super.key});

  @override
  State<PublicacionView> createState() => _PublicacionViewState();
}

class _PublicacionViewState extends State<PublicacionView> {
  late PublicacionBloc _bloc;
  final PublicidadService publicidadService = PublicidadService();
  Future<List<ItemFeed>>? _feedFuture;

  @override
  void initState() {
    super.initState();
    _bloc = PublicacionBloc(PublicacionService(), ComentarioService(), publicidadService);
    _bloc.add(CargarFeed());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  /// Inserta publicidad cada [frecuencia] publicaciones
  Future<List<ItemFeed>> _insertarPublicidad(List publicaciones, {int frecuencia = 4}) async {
    final List<ItemFeed> feedConPublicidad = [];

    List<Publicidad> publicidadesActivas = [];
    try {
      final todas = await publicidadService.listarPublicidad();
      publicidadesActivas = todas.where((pub) => pub.estaActivo).toList();
    } catch (e) {
       debugPrint('[Publicidad] Error al cargar publicidad: $e');
    }

    if (publicidadesActivas.isEmpty) {
      // Si no hay publicidad activa, devolver solo publicaciones
      return publicaciones.map((p) => ItemFeed.publicacion(p)).toList();
    }

    int indicePublicidad = 0;

    for (int i = 0; i < publicaciones.length; i++) {
      feedConPublicidad.add(ItemFeed.publicacion(publicaciones[i]));
      if ((i + 1) % frecuencia == 0) {
        feedConPublicidad.add(
          ItemFeed.publicidad(
            publicidadesActivas[indicePublicidad % publicidadesActivas.length],
          ),
        );
        indicePublicidad++;
      }
    }

    return feedConPublicidad;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<PublicacionBloc, PublicacionState>(
        listener: (context, state) {
          if (state is FeedCargado) {
            setState(() {
              _feedFuture = _insertarPublicidad(state.publicaciones);
            });
          }
        },
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
            return FutureBuilder<List<ItemFeed>>(
              future: _feedFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFC7E39)),
                  );
                }
                final feed = snapshot.data ?? state.publicaciones
                    .map((p) => ItemFeed.publicacion(p))
                    .toList();

                return RefreshIndicator(
                  color: const Color(0xFFFC7E39),
                  backgroundColor: const Color(0xFF232120),
                  onRefresh: () async => _bloc.add(CargarFeed()),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    itemCount: feed.length,
                    itemBuilder: (context, index) {
                      final item = feed[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: item.esPublicacion
                            ? PublicacionWidget(publicacion: item.publicacion!)
                            : PublicidadWidget(publicidad: item.publicidad!),
                      );
                    },
                  ),
                );
              },
            );
          }

          // ── Estado inicial (nunca visible) ────────────────
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
