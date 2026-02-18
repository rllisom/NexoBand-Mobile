import 'package:flutter/material.dart';

class BandasUsuarioPage extends StatefulWidget {
  const BandasUsuarioPage({super.key});

  @override
  State<BandasUsuarioPage> createState() => _BandasUsuarioPageState();
}

class _BandasUsuarioPageState extends State<BandasUsuarioPage> {
  // Datos de ejemplo — sustituir por datos reales al integrar la API
  final List<Map<String, dynamic>> bandas = [
    {
      'nombre': 'The Electric Souls',
      'descripcion': 'Banda de rock alternativo formada en 2018',
      'imagen': 'https://www.figma.com/api/mcp/asset/9cf87802-11a1-42f8-8fee-8c85f8a3966e',
      'generos': ['Rock', 'Alternativo'],
      'seguidores': 8543,
    },
    {
      'nombre': 'Jazz Collective',
      'descripcion': 'Explorando las fronteras del jazz contemporáneo',
      'imagen': 'https://www.figma.com/api/mcp/asset/55a193df-802c-4d72-a581-fc50819f07c8',
      'generos': ['Jazz', 'Fusión', 'Experimental'],
      'seguidores': 3210,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d1817),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232120),
        elevation: 0,
        title: const Text(
          'Mis bandas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFFef365b), Color(0xFFfd8835)],
                ),
              ),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white, size: 18),
                label: const Text(
                  'Nueva banda',
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: bandas.isEmpty
          ? const Center(
              child: Text(
                'Todavía no perteneces a ninguna banda',
                style: TextStyle(color: Color(0xFF9ca3af), fontSize: 15),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bandas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final banda = bandas[index];
                return _BandaCard(
                  nombre: banda['nombre'],
                  descripcion: banda['descripcion'],
                  imagen: banda['imagen'],
                  generos: List<String>.from(banda['generos']),
                  seguidores: banda['seguidores'],
                );
              },
            ),
    );
  }
}

class _BandaCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String imagen;
  final List<String> generos;
  final int seguidores;

  const _BandaCard({
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.generos,
    required this.seguidores,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232120),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen de la banda
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imagen,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Nombre, descripción y géneros
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  descripcion,
                  style: const TextStyle(
                    color: Color(0xFF9ca3af),
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: generos
                      .map(
                        (g) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2d2a28),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            g,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Seguidores
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatNum(seguidores),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'seguidores',
                style: TextStyle(
                  color: Color(0xFF9ca3af),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}k';
    }
    return n.toString();
  }
}