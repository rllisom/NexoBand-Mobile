import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/config/obtener_usuario_registrado.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';
import 'package:nexoband_mobile/features/chat/bloc/chat_bloc.dart';
import 'package:nexoband_mobile/features/chat/ui/chat_detail_view.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {

  late ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc(ChatService())
    ..add(CargarChats());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(ChatService())..add(CargarChats()),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return FutureBuilder<int>(
            future: ObtenerUsuarioRegistrado.getUserId(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFFC7E39)));
              }

              final myUserId = snapshot.data!;
              
              if (state is ChatsCargando) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFFC7E39)));
              }

              if (state is ChatsCargados) {
                final chats = state.chats;
                if (chats.isEmpty) return const Center(child: Text('No tienes chats activos', style: TextStyle(color: Colors.white, fontSize: 16)));
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chats.length,
                  itemBuilder: (context, index) => _ChatTile(
                    chat: chats[index],
                    myUserId: myUserId,
                  ),
                );
              }

              if (state is ChatsCargaError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 64),
                      const SizedBox(height: 16),
                      Text(state.mensaje, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<ChatBloc>().add(CargarChats()),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFC7E39)),
                        child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}



class _ChatTile extends StatelessWidget {
  final ChatResponse chat;
  final int myUserId;

  const _ChatTile({required this.chat, required this.myUserId});

  Usuario get _otroUsuario {
    return myUserId == chat.usuario1.id ? chat.usuario2 : chat.usuario1;
  }

  String get _lastMessage {
    return chat.mensajes.isNotEmpty 
        ? (chat.mensajes.last.texto ?? 'Sin mensaje')
        : 'Empieza la conversación';
  }

  bool get _hasValidImage {
    final img = _otroUsuario.imgPerfil;
    return img != null && (img.startsWith('http://') || img.startsWith('https://'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatDetailView(chat: chat)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: ClipOval(
                    child: _hasValidImage
                        ? Image.network(_otroUsuario.imgPerfil!, fit: BoxFit.cover)
                        : Container(
                            color: const Color(0xFF2D2A28),
                            child: const Icon(Icons.person, color: Colors.white54, size: 28),
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _otroUsuario.username ?? 'Usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _lastMessage,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}