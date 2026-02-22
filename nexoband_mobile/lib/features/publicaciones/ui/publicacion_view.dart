import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/widget/publicacion_widget.dart';

class PublicacionView extends StatelessWidget {
  final List<Publicacion> publicaciones;
  const PublicacionView({super.key, required this.publicaciones});

  @override
  Widget build(BuildContext context) {

    // Si no hay publicaciones mostramos mensaje
    if (publicaciones.isEmpty) {
      return const Center(
        child: Text(
          'No hay publicaciones...\n¡Empieza a seguir a artistas y bandas!',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Si hay publicaciones mostramos la lista
    return ListView.builder(
      itemCount: publicaciones.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: PublicacionWidget(publicacion: publicaciones[index]),
        );
      },
    );
  }
}
