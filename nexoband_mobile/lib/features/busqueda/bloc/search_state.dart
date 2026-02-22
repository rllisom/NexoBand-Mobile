part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchCargando extends SearchState {}

final class SearchResultados extends SearchState {
  final List<UsuarioSearchResponse> usuarios;
  final List<BandaSearchResponse> bandas;

  SearchResultados({required this.usuarios, required this.bandas});
  bool get vacio => usuarios.isEmpty && bandas.isEmpty;
}

final class SearchError extends SearchState {
  final String mensaje;
  SearchError(this.mensaje);
}