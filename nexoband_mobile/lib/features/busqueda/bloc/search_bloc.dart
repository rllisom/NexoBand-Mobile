import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/model/banda_search_response.dart';
import 'package:nexoband_mobile/core/model/usuario_search_response.dart';
import 'package:nexoband_mobile/core/service/search_service.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchService searchService;
  SearchBloc(this.searchService) : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      if (event is BuscarTodo) {
        if (event.query.trim().isEmpty) {
          emit(SearchInitial());
          return;
        }
        emit(SearchCargando());
        try {
          // Las dos llamadas en paralelo
          final resultados = await Future.wait([
            searchService.buscarUsuarios(event.query),
            searchService.buscarBandas(event.query),
          ]);
          emit(
            SearchResultados(
              usuarios: resultados[0] as List<UsuarioSearchResponse>,
              bandas: resultados[1] as List<BandaSearchResponse>,
            ),
          );
        } catch (e) {
          emit(SearchError(e.toString()));
        }
      }
    });
    on<LimpiarBusqueda>((event, emit) => emit(SearchInitial()));
  }
}
