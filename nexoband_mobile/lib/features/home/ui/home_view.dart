import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';
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

  Widget _getBody(){
    if(_selectedIndex == 0){
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
            return Container();
          },
        ),
      );
    }else{
      return Container();
    }
  }

  @override
  void initState(){
    super.initState();
    _selectedIndex = 0;
    homePageBloc = HomePageBloc(PublicacionService())..add(CargarPublicacionesUsuario());
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
        body: _getBody(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF232120),
          unselectedItemColor: Color(0xFF9CA3AF),
          selectedItemColor: Color(0xFFCC5200),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index){
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Inicio"
            ),
            BottomNavigationBarItem(icon: Icon(Icons.map),label: "Eventos"),
            BottomNavigationBarItem(icon: Icon(Icons.chat),label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil")
          ]
        ),
      ),
    );
  }
}