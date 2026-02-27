part of 'perfil_bloc.dart';

@immutable
sealed class PerfilEvent {}


final class CargarPerfil extends PerfilEvent {}
final class RefrescarPerfil extends PerfilEvent {}

final class EditarImagenPerfil extends PerfilEvent {
  final int usuarioId;
  final String imagePath;
  EditarImagenPerfil(this.usuarioId, this.imagePath);
}
