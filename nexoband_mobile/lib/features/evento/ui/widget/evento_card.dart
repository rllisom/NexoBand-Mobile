import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/evento_detail_sheet.dart';

class EventoCard extends StatelessWidget {
  final EventoResponse evento;
  final VoidCallback? onEliminado;
  final bool puedeEliminar;

  const EventoCard({
    super.key,
    required this.evento,
    this.onEliminado,
    this.puedeEliminar = false,
  });

  @override
  Widget build(BuildContext context) {
    final fecha = evento.fecha;
    final fechaFormateada = '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: () => EventoDetailSheet.show(context, evento, onEliminado: onEliminado, puedeEliminar: puedeEliminar),
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
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2d2a28), Color(0xFF3a3530)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.event, color: Color(0xFFFC7E39), size: 64),
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
