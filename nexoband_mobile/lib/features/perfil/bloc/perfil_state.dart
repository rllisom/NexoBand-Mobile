part of 'perfil_bloc.dart';

@immutable
sealed class PerfilState {}

final class PerfilInitial extends PerfilState {}

final class PerfilCargando extends PerfilState {}

final class PerfilCargado extends PerfilState {
  final UsuarioResponse usuario;
  PerfilCargado(this.usuario);
}

final class PerfilError extends PerfilState {
  final String mensaje;
  PerfilError(this.mensaje);
}