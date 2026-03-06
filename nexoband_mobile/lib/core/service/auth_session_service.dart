
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/core/dto/login_request.dart';
import 'package:nexoband_mobile/core/interface/auth_session_interface.dart';
import 'package:nexoband_mobile/core/model/auth_session_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionService implements AuthSessionInterface{
  @override
  Future<AuthSessionResponse> iniciarSesion(LoginRequest request) async {
    final url = '${ApiBaseUrl.baseUrl}/auth/login';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final authSessionResponse = AuthSessionResponse.fromJson(jsonDecode(response.body));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authSessionResponse.token);
      await prefs.setInt('user_id', authSessionResponse.user.id);
      return authSessionResponse;
    }

    Map<String, dynamic>? body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>?;
    } catch (_) {}

    switch (response.statusCode) {
      case 400:
        throw Exception(body?['message'] ?? 'La solicitud no es válida');
      case 401:
      case 422:
        throw Exception('Correo electrónico o contraseña incorrectos');
      case 403:
        throw Exception('Cuenta desactivada: contactar con admin@nexoband.com');
      case 404:
        throw Exception('No existe ninguna cuenta con ese correo electrónico');
      case 429:
        throw Exception('Demasiados intentos. Espera un momento e inténtalo de nuevo');
      case 500:
        throw Exception('Error interno del servidor. Inténtalo más tarde');
      default:
        throw Exception(body?['message'] ?? 'Error al iniciar sesión');
    }
  }
}