import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';

class InstrumentoService {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 404: return 'El instrumento no existe o fue eliminado';
      case 422: return body?['message'] ?? 'Datos del instrumento no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }

  Future<Map<String, String>> _headers() async {
    final token = await GuardarToken.getAuthToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Lista todos los instrumentos disponibles en el sistema.
  Future<List<InstrumentoResponse>> listarTodos() async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/instrumentos'),
      headers: await _headers(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      List lista;
      if (decoded is List) {
        lista = decoded;
      } else if (decoded is Map) {
        lista = decoded['data'] ??
            decoded['instrumentos'] ??
            decoded['result'] ??
            decoded.values.firstWhere((v) => v is List, orElse: () => []);
      } else {
        lista = [];
      }
      return lista
          .map((i) => InstrumentoResponse.fromJson(i as Map<String, dynamic>))
          .toList();
    }
    throw Exception(_mensajeError(response.statusCode, 'listar los instrumentos', _parseBody(response.body)));
  }

  /// Agrega un instrumento al usuario.
  Future<void> agregarAUsuario({
    required int usuarioId,
    required int instrumentoId,
    required String nivel,
    required int experiencia,
    String descripcion = '',
    String generos = '',
  }) async {
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/users/$usuarioId/instrumentos'),
      headers: await _headers(),
      body: jsonEncode({
        'users_id':       usuarioId,
        'instrumentos_id': instrumentoId,
        'nivel':          nivel,
        'experiencia':    experiencia,
        'descripcion':    descripcion,
        'generos':        generos,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_mensajeError(response.statusCode, 'agregar el instrumento', _parseBody(response.body)));
    }
  }

  /// Elimina un instrumento del usuario.
  Future<void> eliminarDeUsuario(int usuarioId, int instrumentoId) async {
    final response = await http.delete(
      Uri.parse(
          '${ApiBaseUrl.baseUrl}/users/$usuarioId/instrumentos/$instrumentoId'),
      headers: await _headers(),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_mensajeError(response.statusCode, 'eliminar el instrumento', _parseBody(response.body)));
    }
  }
}
