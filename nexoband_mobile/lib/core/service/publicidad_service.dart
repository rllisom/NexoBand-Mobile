import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/publicidad_interfaz.dart';
import 'package:nexoband_mobile/core/model/publicidad.dart';

class PublicidadService implements PublicidadInterfaz {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }

  @override
  Future<List<Publicidad>> listarPublicidad() async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/publicidades'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body) as List;
      return decoded.map((e) => Publicidad.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception(_mensajeError(response.statusCode, 'cargar las publicidades', _parseBody(response.body)));
  }
}