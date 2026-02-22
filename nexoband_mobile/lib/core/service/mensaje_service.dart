import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/mensaje_interface.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';

class MensajeService implements MensajeInterface {
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
        'chats_id': chatId,
        'users_id': userId,
        'texto': texto,
      }),
    );

    if (response.statusCode == 201) {
      return Mensaje.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al enviar mensaje: ${response.statusCode}');
    }
  }
}