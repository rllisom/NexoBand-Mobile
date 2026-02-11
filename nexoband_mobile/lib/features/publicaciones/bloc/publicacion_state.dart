part of 'publicacion_bloc.dart';

@immutable
sealed class PublicacionState {}

final class PublicacionInitial extends PublicacionState {}

final class DarMeGustaState extends PublicacionState {
  final int idPublicacion;
  final int idUsuario;

  DarMeGustaState(this.idPublicacion, this.idUsuario);
}

final class MeGustaErrorState extends PublicacionState {
  final String errorMessage;

  MeGustaErrorState(this.errorMessage);
}

final class QuitarMeGustaState extends PublicacionState {
  final int idPublicacion;
  final int idUsuario;

  QuitarMeGustaState(this.idPublicacion, this.idUsuario);
}
