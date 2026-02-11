part of 'login_page_bloc.dart';

@immutable
abstract class LoginPageState {}

class LoginPageInitial extends LoginPageState {}

class LoginPageLoading extends LoginPageState {}

class LoginPageSuccess extends LoginPageState {
  final AuthSessionResponse authSessionResponse;
  LoginPageSuccess(this.authSessionResponse);
}

class LoginPageError extends LoginPageState {
  final String errorMessage;
  LoginPageError(this.errorMessage);
}
