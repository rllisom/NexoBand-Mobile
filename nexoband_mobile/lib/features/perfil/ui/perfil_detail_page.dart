
import 'package:flutter/material.dart';

class _PostCard extends StatelessWidget {
  final String userName;
  final String userImage;
  final String timeAgo;
  final String content;
  final String postImage;
  final int likes;
  final int comments;
  final int shares;

  const _PostCard({
    required this.userName,
    required this.userImage,
    required this.timeAgo,
    required this.content,
    required this.postImage,
    required this.likes,
    required this.comments,
    required this.shares,
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
          // Cabecera: avatar + nombre + tiempo
          Row(
            children: [
              ClipOval(
                child: Image.network(userImage, width: 40, height: 40, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  Text(timeAgo,
                      style: const TextStyle(
                          color: Color(0xFF9ca3af), fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Texto
          Text(content,
              style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
          const SizedBox(height: 10),
          // Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(postImage, fit: BoxFit.cover, width: double.infinity),
          ),
          const SizedBox(height: 12),
          // Acciones: likes, comentarios, compartir
          Row(
            children: [
              _ActionButton(icon: Icons.favorite_border, count: likes),
              const SizedBox(width: 20),
              _ActionButton(icon: Icons.chat_bubble_outline, count: comments),
              const SizedBox(width: 20),
              _ActionButton(icon: Icons.share_outlined, count: shares),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  const _ActionButton({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF9ca3af), size: 20),
        const SizedBox(width: 4),
        Text('$count', style: const TextStyle(color: Color(0xFF9ca3af), fontSize: 13)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 2.5),
      decoration: BoxDecoration(
        color: const Color(0xFF2d2a28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.transparent, width: 0.5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class PerfilDetailPage extends StatefulWidget {
  const PerfilDetailPage({super.key});

  @override
  State<PerfilDetailPage> createState() => _PerfilDetailPageState();
}

class _PerfilDetailPageState extends State<PerfilDetailPage> {
  @override
  Widget build(BuildContext context) {
    // URLs de imágenes extraídas del diseño Figma
    const imgImageWithFallback = "https://www.figma.com/api/mcp/asset/e963fded-53a1-47ef-a6e7-21bd5ab742d2";
    return Scaffold(
      backgroundColor: const Color(0xFF1d1817),
      body: Stack(
        children: [
          // AppBar custom
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF232120),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: -0.45,
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(Icons.settings, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Perfil principal
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF232120),
              width: double.infinity,
              height: 285,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.network(imgImageWithFallback, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Alex Rivera',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: -0.44,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '@alexrivera',
                                style: TextStyle(
                                  color: Color(0xFF9ca3af),
                                  fontSize: 16,
                                  letterSpacing: -0.31,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '2547 ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'seguidores',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: '892 ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: 'siguiendo',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Guitarrista profesional y compositor. Amante del rock y el blues.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: -0.31,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Badge(text: 'Guitarra eléctrica'),
                        const SizedBox(width: 8),
                        _Badge(text: 'Guitarra acústica'),
                        const SizedBox(width: 8),
                        _Badge(text: 'Bajo'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1d1817),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size.fromHeight(36),
                        elevation: 0,
                        side: const BorderSide(color: Color(0x1AFFFFFF)),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text('Editar perfil', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Contenido scrollable debajo del perfil
          Positioned(
            top: 345,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Botón Ver mis bandas con gradiente
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFef365b), Color(0xFFfd8835)],
                    ),
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.groups, color: Colors.white, size: 20),
                    label: const Text(
                      'Ver mis bandas',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Cabecera publicaciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mis publicaciones',
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
                          'Crear publicación',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Si hay publicaciones, mostrar tarjeta de ejemplo
                // Cambia esto a un ListView.builder cuando sea dinámico
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PerfilDetailPage())),
                  child: const _PostCard(
                    userName: 'Alex Rivera',
                    userImage: 'https://www.figma.com/api/mcp/asset/e963fded-53a1-47ef-a6e7-21bd5ab742d2',
                    timeAgo: 'Hace 3 horas',
                    content: '¡Acabamos de terminar la grabación de nuestro nuevo single! No puedo esperar a que lo escuchen. 🎸',
                    postImage: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800',
                    likes: 342,
                    comments: 28,
                    shares: 15,
                  ),
                ),
                // Si no hay publicaciones, descomenta esto:
                // const SizedBox(height: 48),
                // const Center(
                //   child: Text(
                //     'Aún no tienes publicaciones',
                //     style: TextStyle(color: Color(0xFF9ca3af), fontSize: 15),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
