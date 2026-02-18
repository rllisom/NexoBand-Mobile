import 'package:flutter/material.dart';

class AjustesSeguidosView extends StatefulWidget {
  const AjustesSeguidosView({super.key});

  @override
  State<AjustesSeguidosView> createState() => _AjustesSeguidosViewState();
}

class _AjustesSeguidosViewState extends State<AjustesSeguidosView> {
  // Datos de ejemplo — sustituir por datos reales al integrar la API
  final List<Map<String, dynamic>> seguidores = [
    {
      'nombre': 'María González',
      'usuario': '@mariaguitar',
      'bio': 'Guitarrista de rock alternativo 🎸',
      'imagen': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      'siguiendo': true,
    },
    {
      'nombre': 'Carlos Drums',
      'usuario': '@carlosbeats',
      'bio': 'Baterista profesional',
      'imagen': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      'siguiendo': true,
    },
    {
      'nombre': 'Ana López',
      'usuario': '@anakeys',
      'bio': 'Piano y teclados | Jazz lover',
      'imagen': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
      'siguiendo': false,
    },
    {
      'nombre': 'Pedro Bass',
      'usuario': '@pedrobass',
      'bio': 'Bajista de funk y soul',
      'imagen': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
      'siguiendo': true,
    },
    {
      'nombre': 'Laura Vocals',
      'usuario': '@laurasings',
      'bio': 'Vocalista y compositora',
      'imagen': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      'siguiendo': false,
    },
    {
      'nombre': 'Javier Sax',
      'usuario': '@javiersax',
      'bio': 'Saxofonista de jazz',
      'imagen': 'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=200',
      'siguiendo': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d1817),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232120),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seguidores',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              '${seguidores.length} seguidores',
              style: const TextStyle(
                color: Color(0xFF9ca3af),
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: seguidores.isEmpty
          ? const Center(
              child: Text(
                'Aún no tienes seguidores',
                style: TextStyle(color: Color(0xFF9ca3af), fontSize: 15),
              ),
            )
          : ListView.separated(
              itemCount: seguidores.length,
              separatorBuilder: (_, __) => const Divider(
                color: Color(0xFF2d2a28),
                height: 1,
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final s = seguidores[index];
                return _SeguidorItem(
                  nombre: s['nombre'],
                  usuario: s['usuario'],
                  bio: s['bio'],
                  imagen: s['imagen'],
                  siguiendo: s['siguiendo'],
                  onToggle: () {
                    setState(() {
                      seguidores[index]['siguiendo'] = !s['siguiendo'];
                    });
                  },
                );
              },
            ),
    );
  }
}

class _SeguidorItem extends StatelessWidget {
  final String nombre;
  final String usuario;
  final String bio;
  final String imagen;
  final bool siguiendo;
  final VoidCallback onToggle;

  const _SeguidorItem({
    required this.nombre,
    required this.usuario,
    required this.bio,
    required this.imagen,
    required this.siguiendo,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Avatar
          ClipOval(
            child: Image.network(
              imagen,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
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
                  style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  bio,
                  style: const TextStyle(color: Color(0xFFd1d5db), fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Botón seguir / siguiendo
          GestureDetector(
            onTap: onToggle,
            child: siguiendo
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2d2a28),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.person, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Siguiendo',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFef365b), Color(0xFFfd8835)],
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.person_add, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Seguir',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
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