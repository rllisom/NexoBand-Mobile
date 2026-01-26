import 'package:flutter/material.dart';
import 'package:nexoband_mobile/ui/publicacion_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  int _selectedIndex = 0;

  Widget _getBody(){
    if(_selectedIndex == 0){
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF1D1817),
        child: PublicacionView(),
      );
    }else{
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            BottomNavigationBarItem(icon: Icon(Icons.search),label: "Buscar"),
            BottomNavigationBarItem(icon: Icon(Icons.chat),label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil")
        ]
        ),
    );
  }
}