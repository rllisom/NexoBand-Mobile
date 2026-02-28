import 'package:flutter/material.dart';
import 'package:nexoband_mobile/config/obtener_usuario_registrado.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';
import 'package:nexoband_mobile/core/service/mensaje_service.dart';
import 'package:nexoband_mobile/features/chat/bloc/chat_bloc.dart';

class ChatDetailView extends StatefulWidget {
  final ChatResponse chat;

  const ChatDetailView({super.key, required this.chat});

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final TextEditingController _controller = TextEditingController();
  final MensajeService _mensajeService = MensajeService();

  late List<Mensaje> _mensajes;
  int? _myUserId;
  Usuario? _otroUsuario;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _mensajes = List.from(widget.chat.mensajes);
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final id = await ObtenerUsuarioRegistrado.getUserId();
    setState(() {
      _myUserId = id;
      _otroUsuario = id == widget.chat.usuario1.id
          ? widget.chat.usuario2
          : widget.chat.usuario1;
    });
  }

  Future<void> _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _myUserId == null || _enviando) return;

    setState(() => _enviando = true);
    _controller.clear();

    try {
      final nuevoMensaje = await _mensajeService.enviarMensaje(
        widget.chat.id,
        _myUserId!,
        texto,
      );
      setState(() {
        _mensajes.add(nuevoMensaje);
      });
    } catch (e) {
      // Si falla, mostramos un snackbar con el error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _enviando = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF232120),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              ChatBloc(ChatService()).add(CargarChats()); // Refrescar lista de chats al volver
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Eliminar chat',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar chat'),
                  content: const Text('¿Seguro que quieres eliminar este chat? Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await ChatService().eliminarChat(widget.chat.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat eliminado'), backgroundColor: Colors.red),
                  );
                }
              }
            },
          ),
        ],
        title: _otroUsuario == null
            ? const CircularProgressIndicator()
            : Row(
                children: [
                  ClipOval(
                    child: _otroUsuario!.imgPerfil != null &&
                            (_otroUsuario!.imgPerfil!.startsWith('http://') ||
                                _otroUsuario!.imgPerfil!.startsWith('https://'))
                        ? Image.network(
                            _otroUsuario!.imgPerfil!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _otroUsuario!.username ?? 'Sin nombre',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) {
                final mensaje = _mensajes[index];
                final esMio = mensaje.usersId == _myUserId;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: esMio
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          gradient: esMio
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFFF5F6D),
                                    Color.fromARGB(255, 250, 180, 83),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: esMio ? null : const Color(0xFF3A3A3A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mensaje.texto ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${mensaje.createdAt.hour.toString().padLeft(2, '0')}:${mensaje.createdAt.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(color: Color(0xFF232120)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF3A3A3A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF5F6D),
                        Color.fromARGB(255, 250, 180, 83),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: _enviando
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _enviarMensaje,
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
