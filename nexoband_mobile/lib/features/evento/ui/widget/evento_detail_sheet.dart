import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/core/service/evento_service.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/icon_gradient_box.dart';

class EventoDetailSheet {
  static void show(BuildContext context, EventoResponse evento, {VoidCallback? onEliminado, bool puedeEliminar = false}) {
    final fecha = evento.fecha;
    final fechaFormateada = '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF232323),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Detalles del evento',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      children: [
                        if (puedeEliminar)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFef365b)),
                          tooltip: 'Eliminar evento',
                          onPressed: () async {
                            final confirmar = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFF232120),
                                title: const Text('Eliminar evento',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                content: Text(
                                  '¿Seguro que quieres eliminar "${evento.nombre}"? Esta acción no se puede deshacer.',
                                  style: const TextStyle(color: Color(0xFF9ca3af)),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancelar',
                                        style: TextStyle(color: Color(0xFF9ca3af))),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Eliminar',
                                        style: TextStyle(color: Color(0xFFef365b), fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );
                            if (confirmar != true) return;
                            try {
                              await EventoService().eliminarEvento(evento.id);
                              if (context.mounted) Navigator.of(context).pop();
                              onEliminado?.call();
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: const Color(0xFFef365b),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  evento.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 8),
                if (evento.bandas.isNotEmpty)
                  Row(
                    children: [
                      const IconGradientBox(icon: Icons.music_note),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Organizado por',
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            evento.bandas.map((b) => b.nombre).join(', '),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const IconGradientBox(icon: Icons.calendar_today),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fecha',
                          style: TextStyle(
                            color: Color(0xFFB0B0B0),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          fechaFormateada,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const IconGradientBox(icon: Icons.location_on),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ubicación',
                          style: TextStyle(
                            color: Color(0xFFB0B0B0),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          evento.lugar,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (evento.descripcion != null) ...[
                  const SizedBox(height: 18),
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    evento.descripcion!,
                    style: const TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 15,
                    ),
                  ),
                ],
                if (evento.aforo != null) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const IconGradientBox(icon: Icons.people),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aforo',
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${evento.aforo} personas',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
