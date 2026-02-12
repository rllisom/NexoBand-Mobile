part of 'home_page_bloc.dart';

@immutable
abstract class HomePageState {}

class HomePageInitial extends HomePageState {}


// Estados relacionados con la carga de publicaciones
class PublicacionesCargando extends HomePageState{}

class PublicacionesCargadas extends HomePageState{
  final List<Publicacion> publicaciones;
  PublicacionesCargadas(this.publicaciones);
}
class PublicacionesCargaError extends HomePageState{
  final String mensaje;
  PublicacionesCargaError(this.mensaje);
}
class PublicacionesCreando extends HomePageState{}

class PublicacionCreada extends HomePageState{
  final Publicacion publicacion;
  PublicacionCreada(this.publicacion);
}

class PublicacionCreacionError extends HomePageState{
  final String mensaje;
  PublicacionCreacionError(this.mensaje);
}

class PublicacionEliminada extends HomePageState{
  final int publicacionId;
  PublicacionEliminada(this.publicacionId);
}

class PublicacionEliminacionError extends HomePageState{
  final String mensaje;
  PublicacionEliminacionError(this.mensaje);
}

//Estados relacionados con la carga de chats

class ChatsCargando extends HomePageState{}
class ChatsCargados extends HomePageState{
  final List<ChatResponse> chats;
  ChatsCargados(this.chats);
}
class ChatsCargaError extends HomePageState{
  final String mensaje;
  ChatsCargaError(this.mensaje);
}