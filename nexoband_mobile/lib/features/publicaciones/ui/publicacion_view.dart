import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/model/item_feed.dart';
import 'package:nexoband_mobile/core/model/publicidad.dart';
import 'package:nexoband_mobile/core/service/comentario_service.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';
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

  @override
  void initState() {
    super.initState();
    _bloc = PublicacionBloc(PublicacionService(),ComentarioService());
    _bloc.add(CargarFeed());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  /// Inserta publicidad cada [frecuencia] publicaciones
  List<ItemFeed> _insertarPublicidad(List publicaciones, {int frecuencia = 4}) {
    final List<ItemFeed> feedConPublicidad = [];
    
    // Publicidades activas de ejemplo (en producción vendrían del backend)
    final publicidadesDisponibles = [
      Publicidad(
        nombreEmpresa: 'Sala Apolo',
        tipoEmpresa: 'Sala de conciertos',
        icono: '🎸',
        estado: true,
        fechaInicio: DateTime.now().subtract(const Duration(days: 10)),
        fechaFinal: DateTime.now().add(const Duration(days: 20)),
        descripcion: 'La mejor sala de conciertos de Barcelona. Próximos eventos: Rock en vivo todos los viernes.',
        nombreContacto: 'Juan García',
        emailContacto: 'info@sala-apolo.com',
        telefonoContacto: '+34 93 441 40 01',
        precioAparicion: 150.0,
        nApariciones: 100,
      ),
      Publicidad(
        nombreEmpresa: 'Music Store BCN',
        tipoEmpresa: 'Tienda de instrumentos',
        icono: '🎹',
        estado: true,
        fechaInicio: DateTime.now().subtract(const Duration(days: 5)),
        fechaFinal: DateTime.now().add(const Duration(days: 25)),
        descripcion: '¡Descuentos de hasta 30% en guitarras, bajos y teclados! Visítanos en nuestras 3 tiendas en Barcelona.',
        nombreContacto: 'María López',
        emailContacto: 'ventas@musicstore-bcn.com',
        telefonoContacto: '+34 93 318 77 80',
        precioAparicion: 200.0,
        nApariciones: 150,
      ),
      Publicidad(
        nombreEmpresa: 'Festival Primavera Sound',
        tipoEmpresa: 'Festival de música',
        icono: '🎉',
        estado: true,
        fechaInicio: DateTime.now().subtract(const Duration(days: 15)),
        fechaFinal: DateTime.now().add(const Duration(days: 35)),
        descripcion: 'Primavera Sound 2024 - Del 29 de mayo al 2 de junio. ¡Entradas ya disponibles!',
        nombreContacto: 'Festival Team',
        emailContacto: 'info@primaverasound.com',
        telefonoContacto: '+34 93 123 45 67',
        precioAparicion: 500.0,
        nApariciones: 300,
      ),
    ];

    // Filtrar solo publicidades activas
    final publicidadesActivas = publicidadesDisponibles
        .where((pub) => pub.estaActivo)
        .toList();

    if (publicidadesActivas.isEmpty) {
      // Si no hay publicidad activa, devolver solo publicaciones
      return publicaciones.map((p) => ItemFeed.publicacion(p)).toList();
    }

    int indicePublicidad = 0;

    for (int i = 0; i < publicaciones.length; i++) {
      // Agregar la publicación normal
      feedConPublicidad.add(ItemFeed.publicacion(publicaciones[i]));

      // Cada [frecuencia] publicaciones, insertar un anuncio
      if ((i + 1) % frecuencia == 0 && publicidadesActivas.isNotEmpty) {
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
            final feedConPublicidad = _insertarPublicidad(state.publicaciones);

            return RefreshIndicator(
              color: const Color(0xFFFC7E39),
              backgroundColor: const Color(0xFF232120),
              onRefresh: () async => _bloc.add(CargarFeed()),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                itemCount: feedConPublicidad.length,
                itemBuilder: (context, index) {
                  final item = feedConPublicidad[index];
                  
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
          }

          // ── Estado inicial (nunca visible) ────────────────
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
