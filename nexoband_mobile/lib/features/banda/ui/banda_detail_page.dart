import 'package:flutter/material.dart';

class BandaDetailPage extends StatelessWidget {
  const BandaDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          title: const Text(
            'The Electric Souls',
            style: TextStyle(
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
        body: Column(
          children: [
            // Cabecera de la banda
            Container(
              color: const Color(0xFF232120),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen + nombre + seguidores + géneros
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://www.figma.com/api/mcp/asset/9cf87802-11a1-42f8-8fee-8c85f8a3966e',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'The Electric Souls',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.music_note, color: Color(0xFF9ca3af), size: 16),
                                SizedBox(width: 4),
                                Text(
                                  '8543 seguidores',
                                  style: TextStyle(color: Color(0xFF9ca3af), fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              children: ['Rock', 'Alternativo', 'Indie']
                                  .map((g) => Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Descripción
                  const Text(
                    'Banda de rock alternativo formada en 2018. Fusionamos elementos clásicos con sonidos modernos.',
                    style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  // Botón Editar banda
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0x33FFFFFF)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0xFF1d1817),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                      label: const Text(
                        'Editar banda',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tab bar
            Container(
              color: const Color(0xFF232120),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF9ca3af),
                indicatorColor: const Color(0xFFef365b),
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(icon: Icon(Icons.image_outlined, size: 18), text: 'Posts'),
                  Tab(icon: Icon(Icons.people_outline, size: 18), text: 'Miembros'),
                  Tab(icon: Icon(Icons.event_outlined, size: 18), text: 'Eventos'),
                ],
              ),
            ),
            // Contenido de tabs
            Expanded(
              child: TabBarView(
                children: [
                  // Posts
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        'Publicaciones de la banda',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _PostCard(
                        nombre: 'The Electric Souls',
                        imagen: 'https://www.figma.com/api/mcp/asset/9cf87802-11a1-42f8-8fee-8c85f8a3966e',
                        timeAgo: 'Hace 2 días',
                        contenido: '¡Nuevo single disponible! 🎸 "Breaking Chains" ya está en todas las plataformas. Gracias por todo el apoyo 🔥',
                        postImagen: 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=800',
                        likes: 142,
                        comentarios: 38,
                      ),
                      // Añade más posts aquí cuando sea dinámico
                    ],
                  ),
                  // Miembros
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const Text(
                        'Miembros de la banda',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      _MiembroCard(
                        nombre: 'Alex Rivera',
                        rol: 'Guitarra · Voz',
                        imagen: 'https://www.figma.com/api/mcp/asset/e963fded-53a1-47ef-a6e7-21bd5ab742d2',
                      ),
                      const SizedBox(height: 8),
                      _MiembroCard(
                        nombre: 'Sarah Connor',
                        rol: 'Teclado · Coros',
                        imagen: 'https://www.figma.com/api/mcp/asset/55a193df-802c-4d72-a581-fc50819f07c8',
                      ),
                    ],
                  ),
                  // Eventos
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Eventos de la banda',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Container(
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.add, color: Colors.white, size: 18),
                              label: const Text(
                                'Crear evento',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          'No hay eventos próximos',
                          style: TextStyle(color: Color(0xFF9ca3af), fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final String nombre;
  final String imagen;
  final String timeAgo;
  final String contenido;
  final String postImagen;
  final int likes;
  final int comentarios;

  const _PostCard({
    required this.nombre,
    required this.imagen,
    required this.timeAgo,
    required this.contenido,
    required this.postImagen,
    required this.likes,
    required this.comentarios,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232120),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(imagen, width: 42, height: 42, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nombre,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(timeAgo,
                      style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(contenido,
              style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(postImagen, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite_border, color: Color(0xFF9ca3af), size: 20),
              const SizedBox(width: 4),
              Text('$likes', style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 13)),
              const SizedBox(width: 20),
              const Icon(Icons.chat_bubble_outline, color: Color(0xFF9ca3af), size: 20),
              const SizedBox(width: 4),
              Text('$comentarios', style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiembroCard extends StatelessWidget {
  final String nombre;
  final String rol;
  final String imagen;

  const _MiembroCard({
    required this.nombre,
    required this.rol,
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232120),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(imagen, width: 46, height: 46, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 2),
              Text(rol,
                  style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}