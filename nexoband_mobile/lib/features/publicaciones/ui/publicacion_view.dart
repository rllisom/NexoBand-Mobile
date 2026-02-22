import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/widget/publicacion_widget.dart';


class PublicacionView extends StatelessWidget {
  final List<Publicacion> publicacion;
  const PublicacionView({super.key, required this.publicacion});

  @override
  Widget build(BuildContext context) {
    return publicacion.isEmpty
        ? Center(
            child: Text(
              'No hay publicaciones... \n¡Empieza a seguir a artistas y bandas!',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: publicacion.length,
            itemBuilder: (context, index) {
              final pub = publicacion[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PublicacionWidget(
                  imgPerfil: pub.user?.imgPerfil ??
                      'https://marketplace.canva.com/A5alg/MAESXCA5alg/1/tl/canva-user-icon-MAESXCA5alg.png',
                  nombreUser: pub.user?.nombre ?? 'Usuario Desconocido',
                  horaPublicacion:
                      '${pub.createdAt.hour}:${pub.createdAt.minute}',
                  descripcion: pub.contenido ?? '',
                  img: pub.multimedia?.url ?? '',
                  comentarios: pub.comentarios.length,
                ),
              );
            },
          );
  }
}