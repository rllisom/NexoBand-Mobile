import 'package:flutter/material.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/model/banda_en_usuario_response.dart';
import 'package:nexoband_mobile/core/model/banda_response.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';
import 'package:nexoband_mobile/features/banda/ui/banda_ajena_view.dart';
import 'package:nexoband_mobile/features/banda/ui/banda_detail_page.dart';

class BandaCard extends StatelessWidget {
  final BandaEnUsuarioResponse banda;

  const BandaCard({required this.banda});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<BandaResponse>(
      future: _cargarBandaDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 80,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            height: 80,
            alignment: Alignment.center,
            child: const Text('Error al cargar banda', style: TextStyle(color: Colors.red)),
          );
        }
        final bandaDetail = snapshot.data!;
        return GestureDetector(
          onTap: () async {
            final esPropietario = await _esPropietario();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => esPropietario
                    ? BandaDetailPage(banda: banda)
                    : BandaAjenaView(bandaId: banda.id),
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
                  child: bandaDetail.imgPerfil != null && bandaDetail.imgPerfil!.isNotEmpty
                      ? Image.network(
                          bandaDetail.imgPerfil!,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImagen(),
                          loadingBuilder: (_, child, progress) =>
                              progress == null ? child : _placeholderImagen(),
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
                        bandaDetail.nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        bandaDetail.descripcion ?? '',
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
                            horizontal: 8,
                            vertical: 3,
                          ),
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
                const Icon(Icons.chevron_right, color: Color(0xFF9ca3af)),
              ],
            ),
          ),
        );
      },
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

  Future<bool> _esPropietario() async {
    final usuarioId = await GuardarToken.getUsuarioId();
    final BandaResponse bandaDetails = await BandaService().getBandaDetail(
      banda.id,
    );

    return bandaDetails.usuarios.any((u) => u.id == usuarioId);
  }

  Future<BandaResponse> _cargarBandaDetail() async {
    return await BandaService().getBandaDetail(banda.id);
  }
}
