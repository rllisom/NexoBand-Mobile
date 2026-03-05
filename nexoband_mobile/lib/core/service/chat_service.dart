import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/chat_request.dart';
import 'package:nexoband_mobile/core/interface/chat_interface.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';

class ChatService implements ChatInterface {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 404: return 'El chat no existe o fue eliminado';
      case 409: return 'Ya existe un chat con ese usuario';
      case 422: return body?['message'] ?? 'Datos del chat no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }

  @override
  Future<ChatResponse> cargarChat(int chatId) async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/chats/$chatId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      return ChatResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(_mensajeError(response.statusCode, 'cargar el chat', _parseBody(response.body)));
  }

  @override
  Future<List<ChatResponse>> cargarChats() async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      return ChatResponse.fromJsonList(jsonDecode(response.body));
    }
    throw Exception(_mensajeError(response.statusCode, 'cargar los chats', _parseBody(response.body)));
  }

  @override
  Future<List<ChatResponse>> searchChats(String query) {
    // TODO: implement searchChats
    throw UnimplementedError();
  }

  Future<ChatResponse> crearChat(ChatRequest request) async {
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 201) {
      return ChatResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(_mensajeError(response.statusCode, 'crear el chat', _parseBody(response.body)));
  }

  Future<void> eliminarChat(int chatId) async {
    final response = await http.delete(
      Uri.parse('${ApiBaseUrl.baseUrl}/chats/$chatId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode != 204) {
      throw Exception(_mensajeError(response.statusCode, 'eliminar el chat', _parseBody(response.body)));
    }
  }
}
