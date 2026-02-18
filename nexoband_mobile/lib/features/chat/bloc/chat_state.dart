part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatCargando extends ChatState {}
final class ChatCargado extends ChatState {
  final ChatResponse chat;
  ChatCargado(this.chat);
}
final class ChatCargadoError extends ChatState {
  final String error;
  ChatCargadoError(this.error);
}