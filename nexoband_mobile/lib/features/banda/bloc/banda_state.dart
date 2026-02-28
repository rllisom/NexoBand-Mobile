part of 'banda_bloc.dart';

@immutable
sealed class BandaState {}

final class BandaInitial extends BandaState {}

class BandaDetailLoading extends BandaState {}

class BandaDetailLoaded extends BandaState {
  final BandaResponse banda;
  BandaDetailLoaded(this.banda);
}

class BandaDetailError extends BandaState {
  final String mensaje;
  BandaDetailError(this.mensaje);
}

class CreandoBanda extends BandaState {}

class BandaCreada extends BandaState {}

class BandaCreacionError extends BandaState {
  final String mensaje;
  BandaCreacionError(this.mensaje);
}

class EditandoBanda extends BandaState {}

class BandaEditada extends BandaState {}

class BandaEdicionError extends BandaState {
  final String mensaje;
  BandaEdicionError(this.mensaje);
}
