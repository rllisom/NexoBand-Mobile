import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/model/banda_en_usuario_response.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';
import 'package:nexoband_mobile/features/banda/bloc/banda_bloc.dart';
import 'package:nexoband_mobile/features/banda/ui/widget/miembro_card.dart';
import 'package:nexoband_mobile/features/evento/ui/widget/evento_card.dart';
import 'package:nexoband_mobile/features/perfil/ui/widget/post_card.dart';


class BandaDetailPage extends StatelessWidget {
  final BandaEnUsuarioResponse banda;

  const BandaDetailPage({super.key, required this.banda});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BandaBloc(bandaService: BandaService())
        ..add(LoadBandaDetail(banda.id)),
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
            title: Text(
              banda.nombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: BlocBuilder<BandaBloc, BandaState>(
            builder: (context, state) {
              if (state is BandaDetailLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFef365b)),
                );
              }
              if (state is BandaDetailError) {
                return Center(
                  child: Text(
                    state.mensaje,
                    style: const TextStyle(color: Color(0xFF9ca3af)),
                  ),
                );
              }
              if (state is BandaDetailLoaded) {
                final b = state.banda;
                return Column(
                  children: [
                    // Cabecera
                    Container(
                      color: const Color(0xFF232120),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: b.imgPerfil != null
                                    ? Image.network(
                                        b.imgPerfil!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _placeholder(),
                                      )
                                    : _placeholder(),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.nombre,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.people_outline,
                                            color: Color(0xFF9ca3af), size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${b.usuarios.length} miembros',
                                          style: const TextStyle(
                                              color: Color(0xFF9ca3af),
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 6,
                                      children: b.grupos
                                          .map((g) => Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF2d2a28),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '${g.icono ?? ''} ${g.nombre}'.trim(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (b.descripcion != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              b.descripcion!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5),
                            ),
                          ],
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Color(0x33FFFFFF)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: const Color(0xFF1d1817),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.edit_outlined,
                                  size: 18, color: Colors.white),
                              label: const Text(
                                'Editar banda',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TabBar
                    Container(
                      color: const Color(0xFF232120),
                      child: TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xFF9ca3af),
                        indicatorColor: const Color(0xFFef365b),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                        tabs: const [
                          Tab(icon: Icon(Icons.image_outlined, size: 18), text: 'Posts'),
                          Tab(icon: Icon(Icons.people_outline, size: 18), text: 'Miembros'),
                          Tab(icon: Icon(Icons.event_outlined, size: 18), text: 'Eventos'),
                        ],
                      ),
                    ),
                    // Tabs
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Posts
                          b.publicaciones.isEmpty
                              ? const Center(
                                  child: Text('No hay publicaciones',
                                      style: TextStyle(
                                          color: Color(0xFF9ca3af),
                                          fontSize: 15)),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: b.publicaciones.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final pub = b.publicaciones[index];
                                    return PostCard(publicacion: pub);
                                  },
                                ),
                          // Miembros
                          b.usuarios.isEmpty
                              ? const Center(
                                  child: Text('Esta banda no tiene miembros',
                                      style: TextStyle(
                                          color: Color(0xFF9ca3af),
                                          fontSize: 15)),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: b.usuarios.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final miembro = b.usuarios[index];
                                    return MiembroCard(
                                      id: miembro.id,
                                      nombre: miembro.user.nombre,
                                      apellidos: miembro.user.apellidos,
                                      username: miembro.user.username,
                                      imgPerfil: miembro.user.imgPerfil,
                                      rol: miembro.rol,
                                    );
                                  },
                                ),
                          // Eventos
                          b.eventos.isEmpty
                              ? const Center(
                                  child: Text('No hay eventos próximos',
                                      style: TextStyle(
                                          color: Color(0xFF9ca3af),
                                          fontSize: 15)),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: b.eventos.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final evento = b.eventos[index];
                                    return EventoCard(evento: evento);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF2d2a28),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.music_note, color: Color(0xFF9ca3af), size: 40),
    );
  }
}
