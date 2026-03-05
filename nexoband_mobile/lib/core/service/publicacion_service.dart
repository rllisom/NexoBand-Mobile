import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/publicacion_request.dart';
import 'package:nexoband_mobile/core/interface/publicacion_interface.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';


class PublicacionService implements PublicacionInterface {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    if (body?['errors'] != null) {
      final errors = body!['errors'] as Map<String, dynamic>;
      return errors.values
          .expand((v) => v is List ? v.map((e) => e.toString()) : [v.toString()])
          .join('\n');
    }
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 404: return 'La publicación no existe o fue eliminada';
      case 422: return body?['message'] ?? 'Datos de la publicación no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  // ── Listar publicaciones del usuario autenticado ──────────────────────────
  @override
  Future<List<Publicacion>> listarPublicacionesUsuario() async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/usuario'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      return _parseLista(decoded);
    }
    Map<String, dynamic>? body;
    try { body = jsonDecode(response.body) as Map<String, dynamic>?; } catch (_) {}
    throw Exception(_mensajeError(response.statusCode, 'cargar publicaciones', body));
  }

  // ── Crear publicación (con o sin multimedia) ──────────────────────────────
  @override
  Future<Publicacion> crearPublicacion(
    PublicacionRequest request, {
    XFile? multimedia,
  }) async {
    final token = await GuardarToken.getAuthToken();
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/multimedia/crear');

    if(request.usersId == null && request.bandasId != null) {
      final usuarioId = await GuardarToken.getUsuarioId();
      request.usersId = usuarioId;
    }

    final multipartRequest = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    // Campos de texto
    final fields = request.toFields();


    multipartRequest.fields.addAll(fields);

  
    // Archivo opcional
    if (multimedia != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath('archivo', multimedia.path),
      );
    }

    final streamed = await multipartRequest.send();
    final response = await http.Response.fromStream(streamed);


    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return Publicacion.fromJson(jsonResponse['publicacion']);
    }
    Map<String, dynamic>? body;
    try { body = jsonDecode(response.body) as Map<String, dynamic>?; } catch (_) {}
    throw Exception(_mensajeError(response.statusCode, 'crear la publicación', body));
  }

  // ── Eliminar publicación ──────────────────────────────────────────────────
  @override
  Future<void> eliminarPublicacion(int publicacionId) async {
    final response = await http.delete(
      Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/$publicacionId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) return;
    Map<String, dynamic>? body;
    try { body = jsonDecode(response.body) as Map<String, dynamic>?; } catch (_) {}
    throw Exception(_mensajeError(response.statusCode, 'eliminar la publicación', body));
  }

  // ── Feed de publicaciones ─────────────────────────────────────────────────
  @override
  Future<List<Publicacion>> listarFeed() async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      return _parseLista(decoded);
    }
    Map<String, dynamic>? body;
    try { body = jsonDecode(response.body) as Map<String, dynamic>?; } catch (_) {}
    throw Exception(_mensajeError(response.statusCode, 'cargar el feed', body));
  }

  // ── Ver detalle ───────────────────────────────────────────────────────────
  @override
  Future<Publicacion> verDetallePublicacion(int publicacionId) async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/$publicacionId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = decoded.containsKey('publicacion')
          ? decoded['publicacion'] as Map<String, dynamic>
          : decoded;
      return Publicacion.fromJson(data);
    }
    Map<String, dynamic>? body;
    try { body = jsonDecode(response.body) as Map<String, dynamic>?; } catch (_) {}
    throw Exception(_mensajeError(response.statusCode, 'cargar el detalle de la publicación', body));
  }


  List<Publicacion> _parseLista(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .map((item) => Publicacion.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    if (decoded is Map<String, dynamic>) {
      final inner = decoded['data'] ?? decoded['publicaciones'];
      if (inner is List) {
        return inner
            .map((item) => Publicacion.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }
}
