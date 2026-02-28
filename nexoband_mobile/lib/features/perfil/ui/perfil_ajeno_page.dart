import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/dto/chat_request.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';
import 'package:nexoband_mobile/features/banda/ui/bandas_usuario_page.dart';
import 'package:nexoband_mobile/features/chat/ui/chat_detail_view.dart';
import 'package:nexoband_mobile/features/perfil/ui/widget/post_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilAjenoPage extends StatelessWidget {
  final UsuarioResponse usuario;

  const PerfilAjenoPage({super.key, required this.usuario});

  Future<int?> obtenerMyUserId() async {
    final prefes = await SharedPreferences.getInstance();
    debugPrint('🗂️ userId: ${prefes.getInt('user_id')}');
    return prefes.getInt('user_id'); 
  }

  void _iniciarChat(int myUserId, int usuarioId, BuildContext context) async {
  try {
    final chatRequest = ChatRequest(
      nombre: null, 
      usuario1Id: myUserId, 
      usuario2Id: usuarioId,
    );

    ChatResponse chat = await ChatService().crearChat(chatRequest);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatDetailView(chat: chat)),
      );
    }catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      body: Stack(
        children: [
          // AppBar custom
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF232120),
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 12),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () async {
                      final myUserId = await obtenerMyUserId();
                      debugPrint('👤 My User ID: $myUserId'); // Debug
                      if (myUserId != null) {
                        _iniciarChat(myUserId, usuario.id,context);
                      }
                    } ,
                  ),
                ],
              ),
            ),
          ),

          // Cabecera del perfil
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF232120),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: usuario.imgPerfil != null
                              ? Image.network(
                                  usuario.imgPerfil!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${usuario.nombre} ${usuario.apellidos}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: -0.44,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${usuario.username}',
                              style: const TextStyle(
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
                                      TextSpan(
                                        text: '${usuario.seguidoresCount} ',
                                        style: const TextStyle(
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
                                      TextSpan(
                                        text: '${usuario.seguidosCount} ',
                                        style: const TextStyle(
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
                  if (usuario.descripcion != null)
                    Text(
                      usuario.descripcion!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: -0.31,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (usuario.instrumentos.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: usuario.instrumentos
                          .take(4)
                          .map((i) => _Badge(text: i.nombre))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),

          // Contenido scrollable
          Positioned(
            top: 100 + calcularAltoCabecera(usuario),
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BandasUsuarioPage(bandas: usuario.bandas),
                        ),
                      ),
                      icon: const Icon(
                        Icons.groups,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        'Ver sus bandas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Cabecera publicaciones (ESTÁTICA)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Sus publicaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: usuario.publicaciones.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 48),
                          child: Center(
                            child: Text(
                              'Este usuario no tiene publicaciones',
                              style: TextStyle(
                                color: Color(0xFF9ca3af),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: usuario.publicaciones.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PostCard(
                              publicacion: usuario.publicaciones[index],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calcularAltoCabecera(UsuarioResponse usuario) {
    double alto = 216; // padding vertical
    if (usuario.instrumentos.length > 2) alto += 30;
    return alto;
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
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
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
