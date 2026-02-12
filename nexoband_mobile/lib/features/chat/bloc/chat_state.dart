part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

// final class ChatsCargando extends ChatState {} 
// final class ChatsCargados extends ChatState { 
//   final List<ChatResponse> chats; 
//   ChatsCargados(this.chats);
// } 
// final class ChatsCargaError extends ChatState { 
//   final String mensaje; 
//   ChatsCargaError(this.mensaje); }

// final class ChatBuscando extends ChatState {}

// final class ChatBuscado extends ChatState { 
//   final List<ChatResponse> resultados; 
//   ChatBuscado(this.resultados); 
// } 
// final class ChatBusquedaError extends ChatState { 
//   final String mensaje; 
//   ChatBusquedaError(this.mensaje); 
// }