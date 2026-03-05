import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/search_interface.dart';
import 'package:nexoband_mobile/core/model/banda_search_response.dart';
import 'package:nexoband_mobile/core/model/usuario_search_response.dart';

class SearchService  implements SearchInterface {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 422: return body?['message'] ?? 'Parámetros de búsqueda no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }
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
    throw Exception(_mensajeError(response.statusCode, 'buscar usuarios', _parseBody(response.body)));
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
    throw Exception(_mensajeError(response.statusCode, 'buscar bandas', _parseBody(response.body)));
  }

  Future<void> agregarMiembro(int bandaId, int id) async {}
  
}