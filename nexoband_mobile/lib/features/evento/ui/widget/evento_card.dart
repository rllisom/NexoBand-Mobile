import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/evento_detail_sheet.dart';

class EventoCard extends StatelessWidget {
  final EventoResponse evento;

  const EventoCard({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    final fecha = DateTime.tryParse(evento.fecha);
    final fechaFormateada = fecha != null
        ? '${fecha.day}/${fecha.month}/${fecha.year}'
        : evento.fecha;

    return GestureDetector(
      onTap: () => EventoDetailSheet.show(context, evento),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF232323),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: evento.bandas.isNotEmpty && evento.bandas.first.imgPerfil != null
                  ? Image.network(
                      evento.bandas.first.imgPerfil!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180,
                      width: double.infinity,
                      color: const Color(0xFF3A3A3A),
                      child: const Icon(Icons.event, color: Colors.white54, size: 60),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFFB0B0B0), size: 14),
                      const SizedBox(width: 6),
                      Text(fechaFormateada,
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, color: Color(0xFFB0B0B0), size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          evento.lugar,
                          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        evento.bandas.isNotEmpty
                            ? evento.bandas.map((b) => b.nombre).join(', ')
                            : 'Sin banda',
                        style: const TextStyle(
                          color: Color(0xFFCC5200),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.people, color: Color(0xFFB0B0B0), size: 14),
                          const SizedBox(width: 4),
                          Text('${evento.asistentesCount}',
                              style: const TextStyle(
                                  color: Color(0xFFB0B0B0), fontSize: 14)),
                        ],
                      ),
                    ],
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
