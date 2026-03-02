import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/features/perfil/ui/perfil_ajeno_page.dart';
import 'package:nexoband_mobile/features/banda/ui/banda_ajena_view.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/publicacion_detail_view.dart';

class PublicacionWidget extends StatefulWidget {
  final Publicacion publicacion;
  const PublicacionWidget({super.key, required this.publicacion});

  @override
  State<PublicacionWidget> createState() => _PublicacionWidgetState();
}

class _PublicacionWidgetState extends State<PublicacionWidget> {
  final PerfilService perfilService = PerfilService();

  Widget _avatarFallback(bool esBanda) => Container(
        color: const Color(0xFF2d2a28),
        child: Icon(
          esBanda ? Icons.music_note : Icons.person,
          color: const Color(0xFF9ca3af),
          size: 22,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final pub = widget.publicacion;
    final user = pub.user;
    final banda = pub.banda;
    final multimedia = pub.multimedia;

    final String autorNombre = banda?.nombre
        ?? user?.username
        ?? 'Usuario desconocido';

    final String? autorImagenRaw = banda != null ? banda.imgPerfil : user?.imgPerfil;
    final String autorImagen = autorImagenRaw ?? '';

    final String hora =
        '${pub.createdAt.hour.toString().padLeft(2, '0')}:'
        '${pub.createdAt.minute.toString().padLeft(2, '0')}';

    return Card(
      color: const Color(0xFF232120),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Cabecera ──────────────────────────────────────
            Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: autorImagen.isNotEmpty
                        ? Image.network(
                            autorImagen,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _avatarFallback(banda != null),
                            loadingBuilder: (_, child, progress) =>
                                progress == null ? child : _avatarFallback(banda != null),
                          )
                        : _avatarFallback(banda != null),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (banda != null && banda.id != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BandaAjenaView(bandaId: banda.id!),
                              ),
                            );
                          } 
                        
                          else if (user != null) {
                            final userResponse = await perfilService.getUsuario(user.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PerfilAjenoPage(usuario: userResponse),
                              ),
                            );
                          }
                        },
                        child: Text(
                          '@$autorNombre',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PublicacionDetailView(publicacion: pub),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.comment_outlined,
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
          ],
        ),
      ),
    );
  }
}
