part of 'publicacion_bloc.dart';

@immutable
sealed class PublicacionEvent {}

final class DarMeGustaPublicacion extends PublicacionEvent{
  final int publicacionId;
  final int usuarioId;
  DarMeGustaPublicacion(this.publicacionId, this.usuarioId);
}

final class QuitarMeGustaPublicacion extends PublicacionEvent{
  final int publicacionId;
  final int usuarioId;
  QuitarMeGustaPublicacion(this.publicacionId, this.usuarioId);
}
