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

final class ImagenPerfilCargando extends PerfilState {}

class ImagenPerfilActualizada extends PerfilState {
  final String nuevaUrl;
  ImagenPerfilActualizada(this.nuevaUrl);
}

class ImagenPerfilError extends PerfilState {
  final String mensaje;
  ImagenPerfilError(this.mensaje);
}