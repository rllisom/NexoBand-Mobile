import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/perfil_interface.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';

class PerfilService implements PerfilInterface {
  @override
  Future<UsuarioResponse> cargarPerfil() async {
    final id = await GuardarToken.getUsuarioId();
    final token = await GuardarToken.getAuthToken();

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/users/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UsuarioResponse.fromJson(json['usuario']);
    }
    throw Exception('Error al cargar el perfil: ${response.statusCode}');
  }

  Future<UsuarioResponse> getUsuario(int usuarioId) async {
    final token = await GuardarToken.getAuthToken();

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/users/$usuarioId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UsuarioResponse.fromJson(json['usuario']);
    }
    throw Exception('Error al cargar el perfil ajeno: ${response.statusCode}');
  }
}