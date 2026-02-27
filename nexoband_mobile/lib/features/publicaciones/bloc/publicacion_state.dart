part of 'publicacion_bloc.dart';

@immutable
sealed class PublicacionState {}

final class PublicacionInitial extends PublicacionState {}

class PublicacionesCargando extends PublicacionState{}

class PublicacionesCargadas extends PublicacionState {
  final List<Publicacion> publicaciones;
  PublicacionesCargadas(this.publicaciones);
}
class PublicacionesCargaError extends PublicacionState{
  final String mensaje;
  PublicacionesCargaError(this.mensaje);
}
class PublicacionesCreando extends PublicacionState{}

class PublicacionCreada extends PublicacionState{
  final Publicacion publicacion;
  PublicacionCreada(this.publicacion);
}

class PublicacionCreacionError extends PublicacionState{
  final String mensaje;
  PublicacionCreacionError(this.mensaje);
}

class PublicacionEliminada extends PublicacionState{
  final int publicacionId;
  PublicacionEliminada(this.publicacionId);
}

class PublicacionEliminacionError extends PublicacionState{
  final String mensaje;
  PublicacionEliminacionError(this.mensaje);
}

class FeedCargando extends PublicacionState {}

class FeedCargado extends PublicacionState {
  final List<Publicacion> publicaciones;
  FeedCargado(this.publicaciones);
}

class FeedVacio extends PublicacionState {}

class FeedCargaError extends PublicacionState {
  final String mensaje;
  FeedCargaError(this.mensaje);
}


