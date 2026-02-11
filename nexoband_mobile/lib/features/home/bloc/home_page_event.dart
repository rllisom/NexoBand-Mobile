part of 'home_page_bloc.dart';

@immutable
abstract class HomePageEvent {}

final class CargarPublicacionesUsuario extends HomePageEvent{}
final class CrearPublicacion extends HomePageEvent{
  final PublicacionRequest request;
  CrearPublicacion(this.request);
}
final class EliminarPublicacion extends HomePageEvent{
  final int publicacionId;
  EliminarPublicacion(this.publicacionId);
}
final class VerDetallePublicacion extends HomePageEvent{
  final int publicacionId;
  VerDetallePublicacion(this.publicacionId);
}