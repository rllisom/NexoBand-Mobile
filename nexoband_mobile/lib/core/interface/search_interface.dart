import 'package:nexoband_mobile/core/model/usuario_search_response.dart';
import 'package:nexoband_mobile/core/model/banda_search_response.dart';
abstract class SearchInterface {
  Future<List<UsuarioSearchResponse>> buscarUsuarios(String query);
  Future<List<BandaSearchResponse>> buscarBandas(String query);
}