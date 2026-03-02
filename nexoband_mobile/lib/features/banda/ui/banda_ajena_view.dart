import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';
import 'package:nexoband_mobile/features/banda/bloc/banda_bloc.dart';
import 'package:nexoband_mobile/features/banda/ui/widget/miembro_card.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/evento_card.dart';
import 'package:nexoband_mobile/features/perfil/ui/widget/post_card.dart';

/// Vista de banda ajena (solo lectura)
/// Sin botones de edición, creación de publicaciones o eventos
class BandaAjenaView extends StatefulWidget {
  final int bandaId;
  const BandaAjenaView({super.key, required this.bandaId});

  @override
  State<BandaAjenaView> createState() => _BandaAjenaViewState();
}

class _BandaAjenaViewState extends State<BandaAjenaView> {
  final BandaService bandaService = BandaService();

  // ─── Helper: avatar con errorBuilder ────────────────────────────────
  Widget _buildAvatar(String? url, double size) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _iconoMusica(size),
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : SizedBox(
                width: size, height: size,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFC7E39), strokeWidth: 2,
                  ),
                ),
              ),
      );
    }
    return _iconoMusica(size);
  }

  Widget _iconoMusica(double size) => Container(
    width: size, height: size,
    decoration: const BoxDecoration(
      color: Color(0xFF2d2a28),
    ),
    child: const Icon(Icons.music_note, color: Color(0xFF9ca3af), size: 40),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BandaBloc(bandaService: bandaService)
        ..add(LoadBandaDetail(widget.bandaId)),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color(0xFF1d1817),
          appBar: AppBar(
            backgroundColor: const Color(0xFF232120),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Banda',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          body: BlocConsumer<BandaBloc, BandaState>(
            listener: (context, state) {
              if (state is BandaDetailError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.mensaje), backgroundColor: Colors.red));
              }
            },
            builder: (context, state) {
              if (state is BandaDetailLoading || state is BandaInitial) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFef365b)));
              }
              if (state is BandaDetailError) {
                return Center(child: Text(state.mensaje,
                  style: const TextStyle(color: Color(0xFF9ca3af))));
              }
              if (state is BandaDetailLoaded) {
                final b = state.banda;

                return Column(
                  children: [
                    // ─── Cabecera ────────────────────────────────────
                    Container(
                      color: const Color(0xFF232120),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Foto perfil (sin botón editar)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _buildAvatar(b.imgPerfil, 100), 
                              ),
                              const SizedBox(width: 16),
                              // Info banda
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(b.nombre,
                                      style: const TextStyle(color: Colors.white,
                                          fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    if (b.genero != null)
                                      Row(children: [
                                        const Icon(Icons.music_note, color: Color(0xFFFC7E39), size: 14),
                                        const SizedBox(width: 4),
                                        Text(b.genero!,
                                          style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 13)),
                                      ]),
                                    if (b.categoria != null) ...[
                                      const SizedBox(height: 4),
                                      Row(children: [
                                        const Icon(Icons.category_outlined, color: Color(0xFF9ca3af), size: 14),
                                        const SizedBox(width: 4),
                                        Text(b.categoria!.nombre,
                                          style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 13)),
                                      ]),
                                    ],
                                    const SizedBox(height: 8),
                                    Row(children: [
                                      _statChip(Icons.people_outline, '${b.usuarios.length}', 'miembros'),
                                      const SizedBox(width: 12),
                                      _statChip(Icons.favorite_border, '${b.seguidoresCount}', 'seguidores'),
                                    ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (b.descripcion != null) ...[
                            const SizedBox(height: 14),
                            Text(b.descripcion!,
                              style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
                          ],
                        ],
                      ),
                    ),

                    // ─── TabBar ──────────────────────────────────────
                    Container(
                      color: const Color(0xFF232120),
                      child: const TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Color(0xFF9ca3af),
                        indicatorColor: Color(0xFFef365b),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        tabs: [
                          Tab(icon: Icon(Icons.image_outlined, size: 18), text: 'Posts'),
                          Tab(icon: Icon(Icons.people_outline, size: 18), text: 'Miembros'),
                          Tab(icon: Icon(Icons.event_outlined, size: 18), text: 'Eventos'),
                        ],
                      ),
                    ),

                    // ─── Tabs (sin botones de acción) ────────────────
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Posts (sin botón "Nueva publicación")
                          b.publicaciones == null || b.publicaciones!.isEmpty
                              ? _emptyState(Icons.image_outlined, 'Sin publicaciones')
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: b.publicaciones!.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (_, i) =>
                                      PostCard(publicacion: b.publicaciones![i]),
                                ),

                          // Miembros (sin botón "Agregar miembro")
                          b.usuarios.isEmpty
                              ? _emptyState(Icons.people_outline, 'Sin miembros')
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: b.usuarios.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (_, i) {
                                    final miembro = b.usuarios[i];
                                    return MiembroCard(miembro: miembro);
                                  },
                                ),

                          // Eventos (sin botón "Crear evento")
                          b.eventos.isEmpty
                              ? _emptyState(Icons.event_outlined, 'Sin eventos')
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: b.eventos.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (_, i) => EventoCard(evento: b.eventos[i]),
                                ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String value, String label) => Row(
    children: [
      Icon(icon, color: const Color(0xFF9ca3af), size: 14),
      const SizedBox(width: 4),
      Text('$value $label',
        style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 12)),
    ],
  );

  Widget _emptyState(IconData icon, String mensaje) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF9ca3af), size: 48),
        const SizedBox(height: 12),
        Text(mensaje, style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 15)),
      ],
    ),
  );
}
