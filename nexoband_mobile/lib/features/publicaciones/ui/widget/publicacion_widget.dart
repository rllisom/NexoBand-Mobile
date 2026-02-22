import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';

class PublicacionWidget extends StatefulWidget {
  final Publicacion publicacion;
  const PublicacionWidget({super.key, required this.publicacion});

  @override
  State<PublicacionWidget> createState() => _PublicacionWidgetState();
}

class _PublicacionWidgetState extends State<PublicacionWidget> {
  bool _showComentarios = false;

  @override
  Widget build(BuildContext context) {
    final pub = widget.publicacion;
    final user = pub.user;
    final banda = pub.banda;
    final multimedia = pub.multimedia;

    final String autorNombre = banda?.nombre
        ?? user?.nombre
        ?? 'Usuario desconocido';

    final String autorImagen = banda?.imgPerfil
        ?? user?.imgPerfil
        ?? 'https://marketplace.canva.com/A5alg/MAESXCA5alg/1/tl/canva-user-icon-MAESXCA5alg.png';

    final String hora =
        '${pub.createdAt.hour.toString().padLeft(2, '0')}:'
        '${pub.createdAt.minute.toString().padLeft(2, '0')}';

    return Card(
      color: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Cabecera ──────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(autorImagen),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: Colors.grey[800],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        autorNombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        hora,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Título ────────────────────────────────────────
            if (pub.titulo != null && pub.titulo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  pub.titulo!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),

            // ── Contenido ─────────────────────────────────────
            if (pub.contenido != null && pub.contenido!.isNotEmpty)
              Text(
                pub.contenido!,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),

            // ── Imagen multimedia ─────────────────────────────
            if (multimedia != null && multimedia.url.isNotEmpty) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  multimedia.url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 180,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white54),
                      ),
                    );
                  },
                ),
              ),
            ],

            const Divider(color: Colors.white12, height: 20),

            // ── Pie: botón comentarios ────────────────────────
            GestureDetector(
              onTap: () => setState(() => _showComentarios = !_showComentarios),
              child: Row(
                children: [
                  Icon(
                    _showComentarios
                        ? Icons.comment
                        : Icons.comment_outlined,
                    color: Colors.white54,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${pub.comentarios.length} comentario${pub.comentarios.length == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),

            // ── Lista de comentarios (expandible) ────────────
            if (_showComentarios && pub.comentarios.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...pub.comentarios.map(
                (c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person_outline,
                          color: Colors.white38, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          c.contenidoTexto,
                          style: const TextStyle(
                              color: Colors.white60, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (_showComentarios && pub.comentarios.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Sin comentarios todavía.',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
