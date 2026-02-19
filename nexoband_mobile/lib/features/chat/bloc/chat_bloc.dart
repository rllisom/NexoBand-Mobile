import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';
import 'package:nexoband_mobile/core/service/chat_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;

  ChatBloc(this.chatService) : super(ChatInitial()) {
    on<CargarChats>((event, emit) async {
      emit(ChatsCargando());
      try {
        final chats = await chatService.cargarChats();
        emit(ChatsCargados(chats));
      } catch (e) {
        emit(ChatsCargaError(e.toString()));
      }
    });
  }
}