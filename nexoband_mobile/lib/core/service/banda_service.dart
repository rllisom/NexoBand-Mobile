
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/banda_request.dart';
import 'package:nexoband_mobile/core/interface/banda_interfaz.dart';
import 'package:nexoband_mobile/core/model/banda_response.dart';
import 'package:nexoband_mobile/core/model/grupo_response.dart';


class BandaService implements BandaInterfaz {
  
  @override
  Future<BandaResponse> getBandaDetail(int bandaId) async {
    
    var response = await http.get(Uri.parse('${ApiBaseUrl.baseUrl}/bandas/$bandaId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      debugPrint('[BandaService] getBandaDetail response: ${response.body}');
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      // El backend envuelve la respuesta en { "banda": {...} }
      final bandaJson = (json['banda'] ?? json) as Map<String, dynamic>;
      return BandaResponse.fromJson(bandaJson);
    } else {
      throw Exception('Error al cargar los detalles de la banda');
    }
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
    } else {
      throw Exception('Error al cargar los grupos');
    }
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
    } else {
      throw Exception('Error ${response.statusCode}: $responseBody');
    }
  }

  Future<void> editarImagenPerfil(int bandaId, String imagePath) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/bandas/$bandaId/imagen_perfil');
    final multipartRequest = http.MultipartRequest('POST', uri);

    multipartRequest.headers.addAll({
      'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
    });

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

    final response = await multipartRequest.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: $responseBody');
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
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
