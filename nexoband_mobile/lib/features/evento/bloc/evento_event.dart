part of 'evento_bloc.dart';

@immutable
sealed class EventoEvent {}

final class CargarEventos extends EventoEvent {
  final bool soloProximos;
  CargarEventos({this.soloProximos = true});
}

final class CrearEvento extends EventoEvent {
  final EventoRequest dto; 
  CrearEvento(this.dto);
}