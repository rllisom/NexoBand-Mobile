import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/mensaje_interface.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';

class MensajeService implements MensajeInterface {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 404: return 'El chat no existe o fue eliminado';
      case 422: return body?['message'] ?? 'Datos del mensaje no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }

  @override
  Future<Mensaje> enviarMensaje(int chatId, int userId, String texto) async {
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/mensajes'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
      body: jsonEncode({
        'texto': texto,
        'chats_id': chatId,
        'users_id': userId,
      }),
    );

    if (response.statusCode == 201) {
      return Mensaje.fromJson(jsonDecode(response.body));
    }
    throw Exception(_mensajeError(response.statusCode, 'enviar el mensaje', _parseBody(response.body)));
  }
}