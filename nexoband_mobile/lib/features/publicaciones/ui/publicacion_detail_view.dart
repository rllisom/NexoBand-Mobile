import 'package:flutter/material.dart';

class PublicacionDetailView extends StatelessWidget {
  // Simulación de datos. En integración real, pasar Publicacion por constructor.
  const PublicacionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados
    final publicacion = {
      'imgPerfil': 'https://randomuser.me/api/portraits/women/44.jpg',
      'nombreUser': 'Sarah Connor',
      'horaPublicacion': 'Hace 2 horas',
      'descripcion': '¡Acabamos de terminar la grabación de nuestro nuevo single! No puedo esperar a que lo escuchen. 🎤🎵',
      'img': 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
      'likes': 342,
      'comentarios': 3,
      'shares': 15,
      'comentariosList': [
        {
          'imgPerfil': 'https://randomuser.me/api/portraits/men/32.jpg',
          'nombreUser': 'Alex Rivera',
          'comentario': '¡Suena increíble! No puedo esperar a escucharlo completo 🔥',
          'hora': 'Hace 1 hora',
        },
        {
          'imgPerfil': 'https://randomuser.me/api/portraits/men/44.jpg',
          'nombreUser': 'David Kim',
          'comentario': 'La producción está brutal. Felicidades!',
          'hora': 'Hace 1 hora',
        },
      ],
    };

    return Scaffold(
      backgroundColor: const Color(0xFF1D1817),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232120),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Publicación', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Card de la publicación
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF232120),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              publicacion['imgPerfil'] as String,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                publicacion['nombreUser'] as String,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                publicacion['horaPublicacion'] as String,
                                style: const TextStyle(color: Colors.white54, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        publicacion['descripcion'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      if ((publicacion['img'] as String).isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            publicacion['img'] as String,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                              const SizedBox(width: 4),
                              Text('${publicacion['likes']}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.comment, color: Colors.white, size: 24),
                              const SizedBox(width: 4),
                              Text('${publicacion['comentarios']}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.share, color: Colors.white, size: 24),
                              const SizedBox(width: 4),
                              Text('${publicacion['shares']}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Comentarios
                Text(
                  'Comentarios (${publicacion['comentarios']})',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 12),
                ...List.generate((publicacion['comentariosList'] as List).length, (i) {
                  final c = (publicacion['comentariosList'] as List)[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          child: Image.network(
                            c['imgPerfil'] as String,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF232120),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c['nombreUser'] as String,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      c['comentario'] as String,
                                      style: const TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Text(
                                  c['hora'] as String,
                                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          // Caja de comentario
          Container(
            color: const Color(0xFF232120),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    'https://randomuser.me/api/portraits/men/32.jpg',
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Escribe un comentario...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF1D1817),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFCC5200), Color(0xFFCC5200), Color(0xFF232120)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}