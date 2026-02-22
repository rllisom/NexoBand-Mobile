part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class CargarChats extends ChatEvent {}

final class BuscarChat extends ChatEvent { 
  final String query; 
  BuscarChat(this.query); 
}

final class CargarChat extends ChatEvent {
  final ChatResponse chat;
  CargarChat(this.chat);
}

final class EnviarMensaje extends ChatEvent {
  final int chatId;
  final String mensaje;
  EnviarMensaje(this.chatId, this.mensaje);
}