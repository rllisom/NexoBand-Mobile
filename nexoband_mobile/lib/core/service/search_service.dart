import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/search_interface.dart';
import 'package:nexoband_mobile/core/model/banda_search_response.dart';
import 'package:nexoband_mobile/core/model/usuario_search_response.dart';

class SearchService  implements SearchInterface {
  @override
  Future<List<UsuarioSearchResponse>> buscarUsuarios(String query) async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/users?search=$query'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      final List lista = jsonDecode(response.body)['usuarios'];
      return lista.map((u) => UsuarioSearchResponse.fromJson(u)).toList();
    }
    throw Exception('Error al buscar usuarios');
  }

  @override
  Future<List<BandaSearchResponse>> buscarBandas(String query) async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/bandas?search=$query'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      final List lista = jsonDecode(response.body)['bandas'];
      return lista.map((b) => BandaSearchResponse.fromJson(b)).toList();
    }
    throw Exception('Error al buscar bandas');
  }
  
}