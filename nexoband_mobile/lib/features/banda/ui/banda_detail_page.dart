import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexoband_mobile/core/model/banda_en_usuario_response.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';
import 'package:nexoband_mobile/core/service/search_service.dart';
import 'package:nexoband_mobile/core/model/usuario_search_response.dart';
import 'package:nexoband_mobile/features/banda/bloc/banda_bloc.dart';
import 'package:nexoband_mobile/features/banda/ui/widget/miembro_card.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/evento_card.dart';
import 'package:nexoband_mobile/features/perfil/ui/widget/post_card.dart';

class BandaDetailPage extends StatefulWidget {
  final BandaEnUsuarioResponse banda;
  const BandaDetailPage({super.key, required this.banda});

  @override
  State<BandaDetailPage> createState() => _BandaDetailPageState();
}

class _BandaDetailPageState extends State<BandaDetailPage> {

  final SearchService searchService = SearchService();
  final BandaService bandaService = BandaService();
  // ─── Editar foto vía BLoC ────────────────────────────────────────────
  Future<void> _editarFotoPerfil(int bandaId) async {
    final picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (imagen == null || !mounted) return;

    context.read<BandaBloc>().add(   // ✅ Delega al BLoC
      EditarFotoPerfilBanda(bandaId: bandaId, imagePath: imagen.path),
    );
  }

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

  Widget _buildAvatarMiembro(String? url) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFF2d2a28),
      backgroundImage: url != null ? NetworkImage(url) : null,
      onBackgroundImageError: url != null ? (_, __) {} : null,
      child: url == null
          ? const Icon(Icons.person, color: Color(0xFF9ca3af), size: 22)
          : null,
    );
  }

  // ─── Agregar miembro (sin cambios) ──────────────────────────────────
  Future<void> _mostrarAgregarMiembros(BuildContext ctx, int bandaId) async {
    final searchCtrl = TextEditingController();
    List<UsuarioSearchResponse> resultados = [];
    bool buscando = false;
    int? agregando;

    await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1B1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (ctx2, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 20,
            bottom: MediaQuery.of(ctx2).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Agregar miembro',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF9ca3af)),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: searchCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre o usuario...',
                  hintStyle: const TextStyle(color: Color(0xFF6b7280)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF9ca3af)),
                  filled: true,
                  fillColor: const Color(0xFF242220),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E2C2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E2C2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFC7E39)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (q) async {
                  if (q.trim().isEmpty) {
                    setSheetState(() => resultados = []);
                    return;
                  }
                  setSheetState(() => buscando = true);
                  try {
                    final res = await searchService.buscarUsuarios(q.trim());
                    setSheetState(() { resultados = res; buscando = false; });
                  } catch (_) {
                    setSheetState(() => buscando = false);
                  }
                },
              ),
              const SizedBox(height: 8),
              if (buscando)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator(color: Color(0xFFFC7E39), strokeWidth: 2)),
                )
              else if (resultados.isEmpty && searchCtrl.text.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('Sin resultados', style: TextStyle(color: Color(0xFF9ca3af)))),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: resultados.length,
                    separatorBuilder: (_, __) => const Divider(color: Color(0xFF2E2C2A), height: 1),
                    itemBuilder: (_, i) {
                      final u = resultados[i];
                      final isAdding = agregando == u.id;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFF2d2a28),
                          backgroundImage: u.imgPerfil != null ? NetworkImage(u.imgPerfil!) : null,
                          child: u.imgPerfil == null
                              ? const Icon(Icons.person, color: Color(0xFF9ca3af), size: 22)
                              : null,
                        ),
                        title: Text('${u.nombre} ${u.apellidos}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        subtitle: Text(u.username,
                          style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 12)),
                        trailing: isAdding
                            ? const SizedBox(width: 20, height: 20,
                                child: CircularProgressIndicator(color: Color(0xFFFC7E39), strokeWidth: 2))
                            : TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFFC7E39),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  setSheetState(() => agregando = u.id);
                                  try {
                                    await bandaService.agregarMiembro(bandaId, u.id);
                                    if (mounted) Navigator.pop(sheetContext);
                                    context.read<BandaBloc>().add(LoadBandaDetail(bandaId));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Miembro agregado correctamente')));
                                  } catch (e) {
                                    setSheetState(() => agregando = null);
                                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')));
                                  }
                                },
                                child: const Text('Agregar',
                                  style: TextStyle(color: Colors.white, fontSize: 13)),
                              ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BandaBloc(bandaService: bandaService)
        ..add(LoadBandaDetail(widget.banda.id)),
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
            title: Text(widget.banda.nombre,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: null,
              ),
            ],
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
              if (state is BandaDetailLoaded || state is BandaFotoSubiendo) {
                // Usamos la banda del último BandaDetailLoaded aunque esté subiendo foto
                final b = state is BandaDetailLoaded
                    ? state.banda
                    : (context.read<BandaBloc>().state is BandaDetailLoaded
                        ? (context.read<BandaBloc>().state as BandaDetailLoaded).banda
                        : null);
                if (b == null) return const SizedBox.shrink();

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
                              // Foto perfil con botón editar
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: state is BandaFotoSubiendo
                                        ? Container(
                                            width: 100, height: 100,
                                            color: const Color(0xFF2d2a28),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xFFFC7E39), strokeWidth: 2),
                                            ),
                                          )
                                        : _buildAvatar(b.imgPerfil, 100),  // ✅ Con errorBuilder
                                  ),
                                  // Botón cámara sobre la foto
                                  Positioned(
                                    bottom: 0, right: 0,
                                    child: GestureDetector(
                                      onTap: state is BandaFotoSubiendo
                                          ? null
                                          : () => _editarFotoPerfil(b.id),  // ✅ Usa BLoC
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFC7E39),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: const Icon(Icons.camera_alt_outlined,
                                          color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
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
                          const SizedBox(height: 10),
                          // Botón editar banda
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFFC7E39)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            ),
                            onPressed: null,
                            icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                            label: const Text('Editar banda',
                              style: TextStyle(color: Colors.white, fontSize: 15)),
                          ),
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

                    // ─── Tabs ────────────────────────────────────────
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Posts
                          b.publicaciones == null || b.publicaciones!.isEmpty
                              ? _emptyState(Icons.image_outlined, 'Sin publicaciones')
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: b.publicaciones!.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                                  itemBuilder: (_, i) => PostCard(publicacion: b.publicaciones![i]),
                                ),

                          // Miembros
                          b.usuarios.isEmpty
                              ? _emptyState(Icons.people_outline, 'Sin miembros')
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: b.usuarios.length + 1, // +1 para el botón
                                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (_, i) {
                                    if (i == b.usuarios.length) {
                                      return SizedBox(
                                        width: double.infinity, height: 44,
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            side: const BorderSide(color: Color(0xFFFC7E39)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          onPressed: () => _mostrarAgregarMiembros(context, b.id),
                                          icon: const Icon(Icons.person_add_outlined,
                                            size: 17, color: Color(0xFFFC7E39)),
                                          label: const Text('Agregar miembro',
                                            style: TextStyle(color: Colors.white, fontSize: 14)),
                                        ),
                                      );
                                    }
                                    final miembro = b.usuarios[i];
                                    return MiembroCard(
                                      miembro: miembro,  // ✅ Con foto correcta
                                    );
                                  },
                                ),

                          // Eventos
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
