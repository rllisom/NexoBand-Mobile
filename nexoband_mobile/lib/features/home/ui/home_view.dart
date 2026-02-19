import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';
import 'package:nexoband_mobile/features/busqueda/ui/search_view.dart';
import 'package:nexoband_mobile/features/chat/bloc/chat_bloc.dart';
import 'package:nexoband_mobile/features/chat/ui/chat_list_view.dart';
import 'package:nexoband_mobile/features/evento/ui/evento_list_view.dart';
import 'package:nexoband_mobile/features/publicaciones/bloc/publicacion_bloc.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/publicacion_view.dart';

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
    _selectedIndex = 0;
    publicacionBloc = PublicacionBloc(PublicacionService())
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
      case 0:
        return 'Publicaciones';
      case 1:
        return 'Eventos';
      case 2:
        return 'Chat';
      case 3:
        return 'Perfil';
      default:
        return 'Inicio';
    }
  }

  Widget _getBody() {
    if (_selectedIndex == 0) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1D1817),
        child: BlocBuilder<PublicacionBloc, PublicacionState>(
          builder: (context, state) {
            if (state is PublicacionesCargando) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PublicacionesCargadas) {
              return PublicacionView(publicacion: state.publicaciones);
            } else if (state is PublicacionesCargaError) {
              return Center(
                child: Text(
                  'Error: ${state.mensaje}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else if (_selectedIndex == 1) {
      return const EventoListView();
    } else if (_selectedIndex == 2) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1D1817),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatsCargando) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatsCargados) {
              return const ChatListView();
            } else if (state is ChatsCargaError) {
              return Center(
                child: Text(
                  'Error: ${state.mensaje}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return Container(); // Aquí irá tu vista de Perfil
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: publicacionBloc),
        BlocProvider.value(value: chatBloc),
      ],
      child: Scaffold(
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
                    onPressed: () {
                      // TODO: Navegar a la pantalla de agregar publicación
                    },
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Eventos"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          ],
        ),
      ),
    );
  }
}
