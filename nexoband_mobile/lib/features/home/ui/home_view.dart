import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';
import 'package:nexoband_mobile/features/chat/ui/chat_list_view.dart';
import 'package:nexoband_mobile/features/home/bloc/home_page_bloc.dart';
import 'package:nexoband_mobile/features/publicaciones/ui/publicacion_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomePageBloc homePageBloc;
  int _selectedIndex = 0;

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
        color: Color(0xFF1D1817),
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state is PublicacionesCargando) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PublicacionesCargadas) {
              return PublicacionView(publicacion: state.publicaciones);
            } else if (state is PublicacionesCargaError) {
              return Center(child: Text('Error: ${state.mensaje}'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else if (_selectedIndex == 2) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF1D1817),
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (state is ChatsCargando) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ChatsCargados) {
              return ChatListView(chats: state.chats);
            } else if (state is ChatsCargaError) {
              return Center(
                child: Text(
                  'Error: ${state.mensaje}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    homePageBloc = HomePageBloc(PublicacionService(), ChatService())
      ..add(CargarPublicacionesUsuario());
  }

  @override
  void dispose() {
    homePageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homePageBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle()),
          backgroundColor: const Color(0xFF232120),
          foregroundColor: Colors.white,
        ),
        body: _getBody(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF232120),
          unselectedItemColor: Color(0xFF9CA3AF),
          selectedItemColor: Color(0xFFCC5200),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              if (index == 2) {
                homePageBloc.add(CargarChats());
              }
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
