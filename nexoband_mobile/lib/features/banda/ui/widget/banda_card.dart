import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/banda_en_usuario_response.dart';
import 'package:nexoband_mobile/features/banda/ui/banda_detail_page.dart';

class BandaCard extends StatelessWidget {
  final BandaEnUsuarioResponse banda;

  const BandaCard({required this.banda});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BandaDetailPage(banda: banda),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF232120),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de la banda
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: banda.imagen != null
                  ? Image.network(
                      banda.imagen!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderImagen(),
                    )
                  : _placeholderImagen(),
            ),
            const SizedBox(width: 12),
            // Nombre, descripción y rol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banda.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    banda.descripcion,
                    style: const TextStyle(
                      color: Color(0xFF9ca3af),
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (banda.rol != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2d2a28),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        banda.rol!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9ca3af),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImagen() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF2d2a28),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.music_note, color: Color(0xFF9ca3af), size: 30),
    );
  }
}
