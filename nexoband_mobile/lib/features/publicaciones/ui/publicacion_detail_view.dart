import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';

class PublicacionDetailView extends StatefulWidget {
  final Publicacion publicacion;
  const PublicacionDetailView({super.key, required this.publicacion});

  @override
  State<PublicacionDetailView> createState() => _PublicacionDetailViewState();
}

class _PublicacionDetailViewState extends State<PublicacionDetailView> {
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  String _formatearHora(DateTime fecha) {
    return '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')} '
        '· ${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final pub = widget.publicacion;

    final String autorNombre = pub.banda?.nombre
        ?? pub.user?.nombre
        ?? 'Usuario desconocido';

    final String autorImagen = pub.banda?.imgPerfil
        ?? pub.user?.imgPerfil
        ?? 'https://marketplace.canva.com/A5alg/MAESXCA5alg/1/tl/canva-user-icon-MAESXCA5alg.png';

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
        title: const Text(
          'Publicación',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                // ── Card publicación ──────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF232120),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Cabecera autor
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(autorImagen),
                            onBackgroundImageError: (_, __) {},
                            backgroundColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                autorNombre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                _formatearHora(pub.createdAt),
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Título
                      if (pub.titulo != null && pub.titulo!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            pub.titulo!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),

                      // Contenido
                      if (pub.contenido != null && pub.contenido!.isNotEmpty)
                        Text(
                          pub.contenido!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),

                      // Imagen multimedia
                      if (pub.multimedia != null &&
                          pub.multimedia!.url.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            pub.multimedia!.url,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const SizedBox(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white54),
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Contador comentarios
                      Row(
                        children: [
                          const Icon(Icons.comment_outlined,
                              color: Colors.white54, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '${pub.comentarios.length} comentario${pub.comentarios.length == 1 ? '' : 's'}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Sección comentarios ───────────────────────
                Text(
                  'Comentarios (${pub.comentarios.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 12),

                if (pub.comentarios.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Sé el primero en comentar.',
                      style: TextStyle(color: Colors.white38, fontSize: 15),
                    ),
                  )
                else
                  ...pub.comentarios.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar genérico (Comentario no trae img del usuario)
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFF3A3A4A),
                            child: Icon(Icons.person,
                                color: Colors.white54, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C2C3A),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    c.contenidoTexto,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 4),
                                  child: Text(
                                    _formatearHora(c.createdAt),
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Caja de nuevo comentario ──────────────────────
          Container(
            color: const Color(0xFF232120),
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              // Sube el campo cuando aparece el teclado
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF3A3A4A),
                  child: Icon(Icons.person, color: Colors.white54, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _comentarioController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un comentario...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF1D1817),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC5200),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // TODO: disparar BLoC event para crear comentario
                      _comentarioController.clear();
                      FocusScope.of(context).unfocus();
                    },
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
