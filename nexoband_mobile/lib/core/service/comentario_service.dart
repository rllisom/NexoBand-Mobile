import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/comentario_request.dart';

class ComentarioService {
  Future<void> crearComentario(ComentarioRequest request) async {
    final token = await GuardarToken.getAuthToken();
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/comentarios'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
    
    if (response.statusCode != 201) {
      throw Exception('Error al crear comentario: ${response.statusCode} ${response.body}');
    }
  }
}