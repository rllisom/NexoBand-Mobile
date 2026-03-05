import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/comentario_request.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';

class ComentarioService {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 404: return 'La publicación no existe o fue eliminada';
      case 422: return body?['message'] ?? 'Datos del comentario no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }

  Future<List<Comentario>> listarComentarios(int publicacionId) async {
    final token = await GuardarToken.getAuthToken();
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/$publicacionId/comentarios'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      final list = decoded is List
          ? decoded
          : (decoded['comentarios'] ?? decoded['data'] ?? []) as List;
      return list
          .map((c) => Comentario.fromJson(c as Map<String, dynamic>))
          .toList();
    }
    throw Exception(_mensajeError(response.statusCode, 'listar los comentarios', _parseBody(response.body)));
  }

  Future<void> crearComentario(ComentarioRequest request) async {
    final token = await GuardarToken.getAuthToken();
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/comentarios'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
    
    if (response.statusCode != 201) {
      throw Exception(_mensajeError(response.statusCode, 'crear el comentario', _parseBody(response.body)));
    }
  }
}