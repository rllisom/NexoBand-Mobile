import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:nexoband_mobile/core/service/chat_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;
  
  ChatBloc(this.chatService) : super(ChatInitial()) {
    on<ChatEvent>((event, emit) async {
      // if (event is CargarChats) {
      //   emit(ChatsCargando());
      //   try {
      //     final chats = await chatService.cargarChats();
      //     emit(ChatsCargados(chats));
      //   } catch (e) {
      //     emit(ChatsCargaError(e.toString()));
      //   } 
      // } else if (event is BuscarChat) {
      //   emit(ChatBuscando());
      //   try {
      //     final resultados = await chatService.searchChats(event.query);
      //     emit(ChatBuscado(resultados));
      //   } catch (e) {
      //     emit(ChatBusquedaError(e.toString()));
      //   }
      // } 
    });
  }
}
