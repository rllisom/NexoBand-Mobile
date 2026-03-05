import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/perfil_interface.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';

class PerfilService implements PerfilInterface {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 404: return 'El usuario no existe o fue eliminado';
      case 422: return body?['message'] ?? 'Datos del perfil no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }
  @override
  Future<UsuarioResponse> cargarPerfil() async {
    final id = await GuardarToken.getUsuarioId();
    final token = await GuardarToken.getAuthToken();

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/users/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UsuarioResponse.fromJson(json['usuario']);
    }
    throw Exception(_mensajeError(response.statusCode, 'cargar el perfil', _parseBody(response.body)));
  }

  Future<UsuarioResponse> getUsuario(int usuarioId) async {
    final token = await GuardarToken.getAuthToken();

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/users/$usuarioId'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UsuarioResponse.fromJson(json['usuario']);
    }
    throw Exception(_mensajeError(response.statusCode, 'cargar el perfil', _parseBody(response.body)));
  }

  

  Future<UsuarioResponse> editarPerfil(int usuarioId, Map<String, String> datos) async {
    final token = await GuardarToken.getAuthToken();

    final response = await http.put(
      Uri.parse('${ApiBaseUrl.baseUrl}/users/$usuarioId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(datos),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      return UsuarioResponse.fromJson(json['usuario'] ?? json);
    }
    throw Exception(_mensajeError(response.statusCode, 'editar el perfil', _parseBody(response.body)));
  }

  Future<String?> editarImagenPerfil(int usuarioId, String imagePath) async {
    final token = await GuardarToken.getAuthToken();
    final uri = Uri.parse(
      '${ApiBaseUrl.baseUrl}/users/$usuarioId/imagen_perfil',
    );

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..files.add(await http.MultipartFile.fromPath('img_perfil', imagePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body);
      return body['img_perfil'] as String?; 
    } else {
      throw Exception(_mensajeError(response.statusCode, 'subir la imagen de perfil', _parseBody(response.body)));
    }
  }
}
