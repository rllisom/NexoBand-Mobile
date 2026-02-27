
sealed class RegistroState {}

final class RegistroInitial extends RegistroState {}

final class RegistroLoading extends RegistroState {}

final class RegistroSuccess extends RegistroState {}

final class RegistroFailure extends RegistroState {
  final String errorMessage;

  RegistroFailure(this.errorMessage);
}