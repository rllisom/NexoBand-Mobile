part of 'publicacion_bloc.dart';

@immutable
sealed class PublicacionEvent {}


final class CargarPublicacionesUsuario extends PublicacionEvent {} 

final class CrearPublicacion extends PublicacionEvent {
  final PublicacionRequest request;
  final XFile? multimedia; 
  CrearPublicacion(this.request, {this.multimedia});
}

final class EliminarPublicacion extends PublicacionEvent {
  final int publicacionId;
  EliminarPublicacion(this.publicacionId);
}

final class VerDetallePublicacion extends PublicacionEvent {
  final int publicacionId;
  VerDetallePublicacion(this.publicacionId);
}

final class CargarFeed extends PublicacionEvent {}


final class EnviarComentario extends PublicacionEvent {
  final ComentarioRequest request;
  EnviarComentario(this.request);
}

