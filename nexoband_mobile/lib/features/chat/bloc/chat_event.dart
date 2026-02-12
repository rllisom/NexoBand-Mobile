part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

final class CargarChats extends ChatEvent {}

final class BuscarChat extends ChatEvent { 
  final String query; 
  BuscarChat(this.query); 
}