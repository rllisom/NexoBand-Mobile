import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/publicacion_request.dart';
import 'package:nexoband_mobile/core/interface/publicacion_interface.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';

class PublicacionService implements PublicacionInterface {
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
    throw Exception(
      'Error al listar publicaciones: ${response.statusCode} - ${response.reasonPhrase}',
    );
  }

  // ── Crear publicación (con o sin multimedia) ──────────────────────────────
  @override
  Future<Publicacion> crearPublicacion(
    PublicacionRequest request, {
    XFile? multimedia,
  }) async {
    final token = await GuardarToken.getAuthToken();
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/multimedia/crear');

    final multipartRequest = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    // Campos de texto
    final fields = request.toFields();
    multipartRequest.fields.addAll(fields);

    // Archivo opcional
    if (multimedia != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath('multimedia', multimedia.path),
      );
    }

    final streamed = await multipartRequest.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return Publicacion.fromJson(jsonResponse['publicacion']);
    }
    throw Exception('Error ${response.statusCode}: ${response.body}');
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
    throw Exception(
      'Error al eliminar publicación: ${response.statusCode} - ${response.reasonPhrase}',
    );
  }

  // ── Feed de publicaciones ─────────────────────────────────────────────────
  @override
  Future<List<Publicacion>> listarFeed() async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/feed'),
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
    throw Exception(
      'Error al cargar feed: ${response.statusCode} - ${response.reasonPhrase}',
    );
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
      return Publicacion.fromJson(jsonDecode(response.body));
    }
    throw Exception(
      'Error al obtener detalle de publicación: ${response.statusCode} - ${response.reasonPhrase}',
    );
  }

  // ── Helper: parsear respuesta a lista de Publicacion ─────────────────────
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
