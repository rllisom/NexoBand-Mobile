part of 'chat_bloc.dart';




sealed class ChatState {}

final class ChatInitial extends ChatState {}


class ChatsCargando extends ChatState{}
class ChatsCargados extends ChatState{
  final List<ChatResponse> chats;
  ChatsCargados(this.chats);
}
class ChatsCargaError extends ChatState{
  final String mensaje;
  ChatsCargaError(this.mensaje);
}

final class ChatCargando extends ChatState {}
final class ChatCargado extends ChatState {
  final ChatResponse chat;
  ChatCargado(this.chat);
}
final class ChatCargadoError extends ChatState {
  final String error;
  ChatCargadoError(this.error);
}