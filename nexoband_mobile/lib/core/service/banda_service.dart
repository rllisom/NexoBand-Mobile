import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/banda_request.dart';
import 'package:nexoband_mobile/core/interface/banda_interfaz.dart';
import 'package:nexoband_mobile/core/model/banda_response.dart';
import 'package:nexoband_mobile/core/model/grupo_response.dart';

class BandaService implements BandaInterfaz {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 404: return 'La banda no existe o fue eliminada';
      case 409: return body?['message'] ?? 'Conflicto al procesar la solicitud';
      case 422: return body?['message'] ?? 'Datos de la banda no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }
  
  @override
  Future<BandaResponse> getBandaDetail(int bandaId) async {
    
    var response = await http.get(Uri.parse('${ApiBaseUrl.baseUrl}/bandas/$bandaId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final bandaJson = (json['banda'] ?? json) as Map<String, dynamic>;
      return BandaResponse.fromJson(bandaJson);
    }
    throw Exception(_mensajeError(response.statusCode, 'cargar los detalles de la banda', _parseBody(response.body)));
  }

  Future<List<GrupoResponse>> getGrupos() async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/grupos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((e) => GrupoResponse.fromJson(e)).toList();
    }
    throw Exception(_mensajeError(response.statusCode, 'cargar los grupos', _parseBody(response.body)));
  }

  Future<void> crearBanda(BandaRequest? request) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/bandas');

    var multipartRequest = http.MultipartRequest('POST', uri);

    // Headers
    multipartRequest.headers.addAll({
      'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
    });

    // Campos texto
    multipartRequest.fields['nombre'] = request!.nombre;
    if (request.genero != null) multipartRequest.fields['genero'] = request.genero!;
    if (request.descripcion != null) multipartRequest.fields['descripcion'] = request.descripcion!;
    if (request.fecCreacion != null) multipartRequest.fields['fec_creacion'] = request.fecCreacion!;
    if (request.categoria != null) multipartRequest.fields['categoria'] = request.categoria!.toString();

    final response = await multipartRequest.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return;
    }
    throw Exception(_mensajeError(response.statusCode, 'crear la banda', _parseBody(responseBody)));
  }

  Future<void> editarImagenPerfil(int bandaId, String imagePath) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/bandas/$bandaId/imagen_perfil');
    final token = await GuardarToken.getAuthToken();

    final multipartRequest = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    final extension = imagePath.split('.').last.toLowerCase();
    final mimeSubtype = switch (extension) {
      'png'  => 'png',
      'webp' => 'webp',
      'gif'  => 'gif',
      _      => 'jpeg',
    };

    multipartRequest.files.add( 
      await http.MultipartFile.fromPath(
        'img_perfil',
        imagePath,
        contentType: http.MediaType('image', mimeSubtype),
      ),
    );

    final streamed = await multipartRequest.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_mensajeError(response.statusCode, 'subir la imagen de la banda', _parseBody(response.body)));
    }
  }

  /// PUT /bandas/{id}  →  edita los datos de la banda
  Future<void> editarBanda(int bandaId, BandaRequest request) async {
    final token = await GuardarToken.getAuthToken();
    final response = await http.put(
      Uri.parse('${ApiBaseUrl.baseUrl}/bandas/$bandaId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response.statusCode, 'editar la banda', _parseBody(response.body)));
    }
  }

  /// POST /users/{userId}/bandas  →  une un usuario a esta banda
  Future<void> agregarMiembro(int bandas_id, int users_id) async {
    final token = await GuardarToken.getAuthToken();
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/users/$users_id/bandas'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'users_id': users_id, 'bandas_id': bandas_id}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(_mensajeError(response.statusCode, 'agregar el miembro a la banda', _parseBody(response.body)));
    }
  }

  Future<void> eliminarMiembro(int bandas_id, int users_id) async {
    final token = await GuardarToken.getAuthToken();
    final response = await http.delete(
      Uri.parse('${ApiBaseUrl.baseUrl}/users/$users_id/bandas/$bandas_id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'users_id': users_id, 'bandas_id': bandas_id}),
    );
    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response.statusCode, 'eliminar el miembro de la banda', _parseBody(response.body)));
    }
  }

  Future<void> eliminarBanda(int id) async {
    final token = await GuardarToken.getAuthToken();
    final response = await http.delete(
      Uri.parse('${ApiBaseUrl.baseUrl}/bandas/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(_mensajeError(response.statusCode, 'eliminar la banda', _parseBody(response.body)));
    }
  }
}
