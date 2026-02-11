part of 'login_page_bloc.dart';

@immutable
abstract class LoginPageEvent {}

final class IniciarSesion extends LoginPageEvent {
  final LoginRequest request;
  IniciarSesion({required this.request});
}
