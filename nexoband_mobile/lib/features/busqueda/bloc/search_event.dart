part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class BuscarTodo extends SearchEvent {
  final String query;
  BuscarTodo(this.query);
}

final class LimpiarBusqueda extends SearchEvent {}