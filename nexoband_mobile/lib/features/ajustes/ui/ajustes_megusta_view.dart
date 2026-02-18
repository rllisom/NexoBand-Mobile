import 'package:flutter/material.dart';

class AjustesMegustaView extends StatefulWidget {
  const AjustesMegustaView({super.key});

  @override
  State<AjustesMegustaView> createState() => _AjustesMegustaViewState();
}

class _AjustesMegustaViewState extends State<AjustesMegustaView> {
  final List<Map<String, dynamic>> _publicaciones = [
    {
      'usuario': 'Alex Rivera',
      'tiempo': 'Hace 3 horas',
      'contenido':
          'Nueva guitarra PRS Custom 24! El tono es absolutamente increíble. No puedo dejar de tocar 🎸✨',
      'imagen': null,
      'likes': 428,
      'comentarios': 52,
      'compartidos': 18,
      'teLiked': true,
    },
    {
      'usuario': 'Alex Rivera',
      'tiempo': 'Hace 1 día',
      'contenido':
          'Ensayo de hoy con The Electric Souls. Estamos afinando detalles para el concierto del 15 de febrero. ¡Los esperamos! 🎶🔥',
      'imagen': null,
      'likes': 312,
      'comentarios': 34,
      'compartidos': 9,
      'teLiked': true,
    },
  ];

  void _toggleLike(int index) {
    setState(() {
      final pub = _publicaciones[index];
      if (pub['teLiked']) {
        pub['likes']--;
        pub['teLiked'] = false;
      } else {
        pub['likes']++;
        pub['teLiked'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Me gusta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '5 publicaciones',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _publicaciones.length,
        itemBuilder: (context, index) {
          final pub = _publicaciones[index];
          return _PostCard(
            usuario: pub['usuario'],
            tiempo: pub['tiempo'],
            contenido: pub['contenido'],
            likes: pub['likes'],
            comentarios: pub['comentarios'],
            compartidos: pub['compartidos'],
            teLiked: pub['teLiked'],
            onLikeTap: () => _toggleLike(index),
          );
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final String usuario;
  final String tiempo;
  final String contenido;
  final int likes;
  final int comentarios;
  final int compartidos;
  final bool teLiked;
  final VoidCallback onLikeTap;

  const _PostCard({
    required this.usuario,
    required this.tiempo,
    required this.contenido,
    required this.likes,
    required this.comentarios,
    required this.compartidos,
    required this.teLiked,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF3A3A3A),
                  child: Icon(Icons.person, color: Colors.white54, size: 22),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      tiempo,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Contenido
            Text(
              contenido,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            // Acciones
            Row(
              children: [
                _ActionButton(
                  icon: teLiked ? Icons.favorite : Icons.favorite_border,
                  label: '$likes',
                  color: teLiked ? Colors.red : Colors.grey,
                  onTap: onLikeTap,
                ),
                const SizedBox(width: 20),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '$comentarios',
                  color: Colors.grey,
                  onTap: () {},
                ),
                const SizedBox(width: 20),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: '$compartidos',
                  color: Colors.grey,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 13),
          ),
        ],
      ),
    );
  }
}