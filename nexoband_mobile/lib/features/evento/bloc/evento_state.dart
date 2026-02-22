part of 'evento_bloc.dart';

@immutable
sealed class EventoState {}

final class EventoInitial extends EventoState {}

final class EventosCargando extends EventoState {}

final class EventosCargados extends EventoState {
  final List<EventoResponse> eventos;
  EventosCargados(this.eventos);
}

final class EventosCargaError extends EventoState {
  final String mensaje;
  EventosCargaError(this.mensaje);
}

final class EventoCreando extends EventoState {}

final class EventoCreado extends EventoState {
  final EventoResponse evento;
  EventoCreado(this.evento);
}

final class EventoCreadoError extends EventoState {
  final String mensaje;
  EventoCreadoError(this.mensaje);
}