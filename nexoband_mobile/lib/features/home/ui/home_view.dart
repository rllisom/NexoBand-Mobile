import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/dto/publicacion_request.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';
import 'package:nexoband_mobile/core/service/comentario_service.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';
import 'package:nexoband_mobile/features/busqueda/ui/search_view.dart';
import 'package:nexoband_mobile/features/chat/bloc/chat_bloc.dart';
import 'package:nexoband_mobile/features/chat/ui/chat_list_view.dart';
import 'package:nexoband_mobile/features/evento/ui/evento_list_view.dart';
import 'package:nexoband_mobile/features/perfil/ui/perfil_detail_page.dart';
import 'package:nexoband_mobile/features/publicaciones/bloc/publicacion_bloc.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/publicacion_view.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/widget/crear_publicacion_modal.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final PublicacionBloc publicacionBloc;
  late final ChatBloc chatBloc;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    publicacionBloc = PublicacionBloc(PublicacionService(),ComentarioService())
      ..add(CargarPublicacionesUsuario());
    chatBloc = ChatBloc(ChatService())
      ..add(CargarChats());
  }

  @override
  void dispose() {
    publicacionBloc.close();
    chatBloc.close();
    super.dispose();
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0: return 'Publicaciones';
      case 1: return 'Eventos';
      case 2: return 'Chat';
      case 3: return 'Perfil';
      default: return 'Inicio';
    }
  }

  Future<void> _abrirCrearPublicacion() async {
    try {
      final usuario = await PerfilService().cargarPerfil();
      if (!mounted) return;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => CrearPublicacionModal(
          usuarioActual: usuario,
          bandasUsuario: usuario.bandas,
          onPublicar: (texto, autorId, autorTipo, multimedia) async {
            final titulo = texto.isEmpty
                ? 'Nueva publicación'
                : (texto.length > 50 ? '${texto.substring(0, 50)}...' : texto);

            final request = PublicacionRequest(
              titulo: titulo,
              contenido: texto,
              usersId: autorTipo == 'usuario' && autorId != null
                  ? int.tryParse(autorId)
                  : null,
              bandasId: autorTipo == 'banda' && autorId != null
                  ? int.tryParse(autorId)
                  : null,
            );

            try {
              await PublicacionService().crearPublicacion(
                request,
                multimedia: multimedia,
              );

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Publicación creada correctamente'),
                    backgroundColor: Color(0xFF22c55e),
                  ),
                );
                // Recargar el feed
                publicacionBloc.add(CargarFeed());
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: $e'),
                    backgroundColor: Color(0xFFef365b),
                  ),
                );
              }
            }
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar usuario: $e'),
            backgroundColor: const Color(0xFFef365b),
          ),
        );
      }
    }
  }

  Widget _getBody() {

    // ── Publicaciones ──────────────────────────────────
    if (_selectedIndex == 0) {
      return BlocBuilder<PublicacionBloc, PublicacionState>(
        bloc: publicacionBloc,
        builder: (context, state) {
          if (state is PublicacionesCargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PublicacionesCargaError) {
            return Center(
              child: Text(
                'Error: ${state.mensaje}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (state is PublicacionesCargadas) {
            return PublicacionView();
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    // ── Eventos ────────────────────────────────────────
    if (_selectedIndex == 1) {
      return const EventoListView();
    }

    // ── Chat ───────────────────────────────────────────
    if (_selectedIndex == 2) {
      return BlocBuilder<ChatBloc, ChatState>(
        bloc: chatBloc,
        builder: (context, state) {
          if (state is ChatsCargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChatsCargaError) {
            return Center(
              child: Text(
                'Error: ${state.mensaje}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (state is ChatsCargados) {
            return const ChatListView();
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    // ── Perfil ─────────────────────────────────────────
    if (_selectedIndex == 3) {
      return PerfilDetailPage();
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1817),
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: const Color(0xFF232120),
        foregroundColor: Colors.white,
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchView()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _abrirCrearPublicacion,
                ),
              ]
            : null,
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF232120),
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedItemColor: const Color(0xFFCC5200),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home),   label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map),    label: 'Eventos'),
          BottomNavigationBarItem(icon: Icon(Icons.chat),   label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
