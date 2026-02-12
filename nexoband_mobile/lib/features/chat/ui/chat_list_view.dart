import 'package:flutter/material.dart';
import 'package:nexoband_mobile/config/obtener_usuario_registrado.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';

class ChatListView extends StatelessWidget {
  final List<ChatResponse> chats;
  
  const ChatListView({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFF1D1817),
      child: chats.isEmpty
          ? Center(
              child: Text(
                'No tienes mensajes...',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : FutureBuilder<int>(
              future: ObtenerUsuarioRegistrado.getUserId(),
              builder: (context, userIdSnapshot) {
                if (!userIdSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final myUserId = userIdSnapshot.data!;
                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    Usuario user = myUserId == chat.usuario1.id
                        ? chat.usuario2
                        : chat.usuario1;
                    String lastMessage = chat.mensajes.isNotEmpty
                        ? chat.mensajes.last.texto
                        : 'Sin mensajes';
                    return ListTile(
                      title: Text(user.username,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(lastMessage,
                          style: TextStyle(color: Colors.white54)),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.imgPerfil ??
                            'https://via.placeholder.com/150'),
                      ),
                      onTap: () {
                        // Navegar a la pantalla de chat individual
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
