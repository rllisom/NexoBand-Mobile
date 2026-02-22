import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/config/obtener_usuario_registrado.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';
import 'package:nexoband_mobile/features/chat/bloc/chat_bloc.dart';
import 'package:nexoband_mobile/features/chat/ui/chat_detail_view.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  int? myUserId;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final id = await ObtenerUsuarioRegistrado.getUserId();
    setState(() {
      myUserId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF1D1817),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatsCargando || myUserId == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsCargados) {
            final chats = state.chats;
            if (chats.isEmpty) {
              return const Center(
                child: Text(
                  'No tienes mensajes...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                Usuario user = myUserId == chat.usuario1.id
                    ? chat.usuario2
                    : chat.usuario1;
                String lastMessage = chat.mensajes.isNotEmpty
                    ? (chat.mensajes.last.texto ?? 'Sin mensaje')
                    : 'Sin mensajes';

                bool hasValidImage = user.imgPerfil != null &&
                    (user.imgPerfil!.startsWith('http://') ||
                        user.imgPerfil!.startsWith('https://'));

                return ListTile(
                  title: Text(
                    user.username ?? 'Usuario',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    lastMessage,
                    style: const TextStyle(color: Colors.white54),
                  ),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[700],
                    backgroundImage: hasValidImage
                        ? NetworkImage(user.imgPerfil!)
                        : null,
                    child: !hasValidImage
                        ? const Icon(Icons.person, color: Colors.white, size: 28)
                        : null,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatDetailView(chat: chat),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is ChatsCargaError) {
            return Center(
              child: Text(
                state.mensaje,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
