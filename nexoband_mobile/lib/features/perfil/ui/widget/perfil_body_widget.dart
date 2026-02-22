import 'package:flutter/material.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';
import 'package:nexoband_mobile/features/ajustes/ui/ajustes_view.dart';
import 'package:nexoband_mobile/features/banda/ui/bandas_usuario_page.dart';
import 'package:nexoband_mobile/features/chat/ui/chat_detail_view.dart';
import 'package:nexoband_mobile/features/perfil/ui/widget/post_card.dart';

class PerfilBodyWidget extends StatelessWidget {
  final UsuarioResponse usuario;
  final bool esPerfilAjeno;

  const PerfilBodyWidget({
    super.key,
    required this.usuario,
    this.esPerfilAjeno = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                // Si es perfil ajeno mostramos botón de volver
                if (esPerfilAjeno)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  )
                else
                  const Text(
                    'Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: -0.45,
                    ),
                  ),
                // Icono ajustes (perfil propio) o chat (perfil ajeno)
                if (esPerfilAjeno)
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline,
                        color: Colors.white, size: 20),
                    onPressed: () => _iniciarChat(context),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.settings,
                        color: Colors.white, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AjustesView(),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),

        // Cabecera del perfil
        Positioned(
          top: 60,
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
                            ? Image.network(usuario.imgPerfil!, fit: BoxFit.cover)
                            : Container(
                                color: Colors.grey[800],
                                child: const Icon(Icons.person,
                                    color: Colors.white54, size: 40),
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
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '${usuario.seguidoresCount} ',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  const TextSpan(
                                    text: 'seguidores',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ]),
                              ),
                              const SizedBox(width: 16),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '${usuario.seguidosCount} ',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  const TextSpan(
                                    text: 'siguiendo',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ]),
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
                        color: Colors.white, fontSize: 16, letterSpacing: -0.31),
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
                const SizedBox(height: 16),

                // Botón editar perfil (solo perfil propio)
                // Botón enviar mensaje (solo perfil ajeno)
                if (!esPerfilAjeno)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1d1817),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size.fromHeight(36),
                      elevation: 0,
                      side: const BorderSide(color: Color(0x1AFFFFFF)),
                    ),
                    onPressed: () {
                      // TODO: navegar a editar perfil
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, size: 16, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Editar perfil',
                            style: TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Contenido scrollable
        Positioned(
          top: 60 + calcularAltoCabecera(usuario),
          left: 0,
          right: 0,
          bottom: 0,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Botón bandas
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BandasUsuarioPage(bandas: usuario.bandas),
                      ),
                    );
                  },
                  icon: const Icon(Icons.groups, color: Colors.white, size: 20),
                  label: Text(
                    esPerfilAjeno ? 'Ver sus bandas' : 'Ver mis bandas',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Cabecera publicaciones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    esPerfilAjeno ? 'Sus publicaciones' : 'Mis publicaciones',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  // Botón crear publicación solo en perfil propio
                  if (!esPerfilAjeno)
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          // TODO: crear publicación
                        },
                        icon: const Icon(Icons.add, color: Colors.white, size: 18),
                        label: const Text(
                          'Crear publicación',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Lista de publicaciones
              if (usuario.publicaciones.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Center(
                    child: Text(
                      esPerfilAjeno
                          ? 'Este usuario no tiene publicaciones'
                          : 'Aún no tienes publicaciones',
                      style: const TextStyle(
                          color: Color(0xFF9ca3af), fontSize: 15),
                    ),
                  ),
                )
              else
                ...usuario.publicaciones.map((pub) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PostCard(publicacion: pub),
                    )),
            ],
          ),
        ),
      ],
    );
  }

  void _iniciarChat(BuildContext context) async {
    try {
      final chat = await ChatService().crearChat(usuario.id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatDetailView(chat: chat)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al iniciar el chat')),
      );
    }
  }

  double calcularAltoCabecera(UsuarioResponse usuario) {
    double alto = 285;
    if (usuario.instrumentos.length > 2) alto += 30;
    if (esPerfilAjeno) alto -= 44; // sin botón de editar
    return alto;
  }
}

class ChatView {
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
