import 'package:flutter/material.dart';

// TODO: Reemplazar con datos reales desde la API
final List<Map<String, dynamic>> _siguiendoEjemplo = [
  {
    'nombre': 'Rock Legends',
    'usuario': '@rocklegends',
    'bio': 'Banda de rock clásico desde 1985',
    'imagen': 'https://i.pravatar.cc/150?img=11',
  },
  {
    'nombre': 'Jazz Collective',
    'usuario': '@jazzcollective',
    'bio': 'Explorando los límites del jazz moderno',
    'imagen': 'https://i.pravatar.cc/150?img=22',
  },
  {
    'nombre': 'Electronic Vibes',
    'usuario': '@electronicvibes',
    'bio': 'Música electrónica experimental',
    'imagen': 'https://i.pravatar.cc/150?img=33',
  },
  {
    'nombre': 'Miguel Torres',
    'usuario': '@migueltorres',
    'bio': 'Productor musical | Beat maker',
    'imagen': 'https://i.pravatar.cc/150?img=44',
  },
  {
    'nombre': 'Sofia Melodías',
    'usuario': '@sofiamelodias',
    'bio': 'Compositora y arreglista',
    'imagen': 'https://i.pravatar.cc/150?img=55',
  },
];

class AjustesSiguiendoView extends StatefulWidget {
  const AjustesSiguiendoView({super.key});

  @override
  State<AjustesSiguiendoView> createState() => _AjustesSiguiendoViewState();
}

class _AjustesSiguiendoViewState extends State<AjustesSiguiendoView> {
  late List<Map<String, dynamic>> _siguiendo;

  @override
  void initState() {
    super.initState();
    // Copia mutable de la lista de ejemplo
    _siguiendo = _siguiendoEjemplo.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void _dejarDeSeguir(int index) {
    setState(() {
      _siguiendo.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d1817),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1d1817),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Siguiendo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '${_siguiendo.length} seguidos',
              style: const TextStyle(
                color: Color(0xFF9ca3af),
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: _siguiendo.isEmpty
          ? const Center(
              child: Text(
                'No sigues a nadie todavía',
                style: TextStyle(color: Color(0xFF9ca3af), fontSize: 15),
              ),
            )
          : ListView.separated(
              itemCount: _siguiendo.length,
              separatorBuilder: (_, __) => const Divider(
                color: Color(0xFF2d2a28),
                height: 1,
                indent: 0,
                endIndent: 0,
              ),
              itemBuilder: (context, index) {
                final item = _siguiendo[index];
                return _SiguiendoItem(
                  nombre: item['nombre'] as String,
                  usuario: item['usuario'] as String,
                  bio: item['bio'] as String,
                  imagen: item['imagen'] as String,
                  onDejarDeSeguir: () => _dejarDeSeguir(index),
                );
              },
            ),
    );
  }
}

class _SiguiendoItem extends StatelessWidget {
  const _SiguiendoItem({
    required this.nombre,
    required this.usuario,
    required this.bio,
    required this.imagen,
    required this.onDejarDeSeguir,
  });

  final String nombre;
  final String usuario;
  final String bio;
  final String imagen;
  final VoidCallback onDejarDeSeguir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          ClipOval(
            child: Image.network(
              imagen,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 52,
                height: 52,
                color: const Color(0xFF2d2a28),
                child: const Icon(Icons.person, color: Color(0xFF9ca3af)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  usuario,
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bio,
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Botón Dejar de seguir
          GestureDetector(
            onTap: onDejarDeSeguir,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2d2a28),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.person_remove_outlined, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Dejar de seguir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}