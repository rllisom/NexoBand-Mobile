import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/banda_search_response.dart';
import 'package:nexoband_mobile/features/banda/ui/banda_ajena_view.dart';

class SearchBandCardWidget extends StatelessWidget {
  final BandaSearchResponse banda;

  const SearchBandCardWidget({super.key, required this.banda});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => BandaAjenaView(bandaId: banda.id)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar de banda
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: banda.imgPerfil != null
                  ? Image.network(
                      banda.imgPerfil!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey[800],
                      child: const Icon(Icons.music_note,
                          color: Colors.white54, size: 28),
                    ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  Text(
                    banda.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Género
                  if (banda.genero != null)
                    Text(
                      banda.genero!,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13),
                    ),
                  const SizedBox(height: 8),
                  // Descripción
                  if (banda.descripcion != null)
                    Text(
                      banda.descripcion!,
                      style: const TextStyle(
                          color: Colors.white38, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

