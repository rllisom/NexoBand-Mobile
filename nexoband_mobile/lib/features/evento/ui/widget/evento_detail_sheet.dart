import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/banda_search_response.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/core/service/evento_service.dart';
import 'package:nexoband_mobile/core/service/search_service.dart';
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
                        if (puedeEliminar)
                          IconButton(
                            icon: const Icon(Icons.group_add, color: Color(0xFF4ADE80)),
                            tooltip: 'Agregar banda',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => _BandaPickerDialog(
                                  eventoId: evento.id,
                                  bandasExistentes: evento.bandas.map((b) => b.id).toList(),
                                ),
                              );
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: evento.bandas
                                .map((b) => Text(
                                      b.nombre,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ))
                                .toList(),
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

// ── Diálogo para buscar y añadir una banda a un evento ──────────────────────
class _BandaPickerDialog extends StatefulWidget {
  final int eventoId;
  final List<int> bandasExistentes;

  const _BandaPickerDialog({
    required this.eventoId,
    required this.bandasExistentes,
  });

  @override
  State<_BandaPickerDialog> createState() => _BandaPickerDialogState();
}

class _BandaPickerDialogState extends State<_BandaPickerDialog> {
  final TextEditingController _ctrl = TextEditingController();
  final SearchService _searchService = SearchService();
  final EventoService _eventoService = EventoService();

  List<BandaSearchResponse> _resultados = [];
  bool _buscando = false;
  bool _agregando = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _buscar(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _resultados = []);
      return;
    }
    setState(() {
      _buscando = true;
      _error = null;
    });
    try {
      final resultados = await _searchService.buscarBandas(query.trim());
      setState(() => _resultados = resultados);
    } catch (e) {
      setState(() => _error = 'Error al buscar bandas');
    } finally {
      setState(() => _buscando = false);
    }
  }

  Future<void> _agregar(BandaSearchResponse banda) async {
    setState(() => _agregando = true);
    try {
      await _eventoService.agregarBanda(widget.eventoId, banda.id);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${banda.nombre}" agregada al evento'),
            backgroundColor: const Color(0xFF22c55e),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _agregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF232323),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Agregar banda',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              onChanged: _buscar,
              decoration: InputDecoration(
                hintText: 'Buscar banda por nombre...',
                hintStyle: const TextStyle(color: Color(0xFF888888)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF888888)),
                filled: true,
                fillColor: const Color(0xFF2C2B29),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            if (_error != null) ...
              [
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Color(0xFFef365b), fontSize: 13)),
              ],
            if (_buscando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(color: Color(0xFFFC7E39))),
              )
            else if (_resultados.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 12),
                  itemCount: _resultados.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: Color(0xFF3A3A3A),
                    height: 1,
                  ),
                  itemBuilder: (context, i) {
                    final banda = _resultados[i];
                    final yaAgregada = widget.bandasExistentes.contains(banda.id);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      leading: ClipOval(
                        child: banda.imgPerfil != null
                            ? Image.network(
                                banda.imgPerfil!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _avatarFallback(),
                              )
                            : _avatarFallback(),
                      ),
                      title: Text(
                        banda.nombre,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: banda.genero != null
                          ? Text(banda.genero!,
                              style: const TextStyle(
                                  color: Color(0xFF9ca3af), fontSize: 12))
                          : null,
                      trailing: yaAgregada
                          ? const Icon(Icons.check_circle,
                              color: Color(0xFF22c55e), size: 22)
                          : _agregando
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFFC7E39), strokeWidth: 2))
                              : IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Color(0xFF4ADE80)),
                                  onPressed: () => _agregar(banda),
                                ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback() => Container(
        width: 40,
        height: 40,
        color: const Color(0xFF3A3A3A),
        child: const Icon(Icons.music_note, color: Colors.white54, size: 20),
      );
}
