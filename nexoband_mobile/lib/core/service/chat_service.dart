import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/chat_request.dart';
import 'package:nexoband_mobile/core/interface/chat_interface.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';

class ChatService implements ChatInterface {
  @override
  Future<ChatResponse> cargarChat(int chatId) async {
    var response = await http.get(
      Uri.parse("${ApiBaseUrl.baseUrl}/chats/$chatId"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      return ChatResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar chat: ${response.statusCode}');
    }
  }

  @override
  Future<List<ChatResponse>> cargarChats() async {
    var response = await http.get(
      Uri.parse("${ApiBaseUrl.baseUrl}/chats"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    if (response.statusCode == 200) {
      return ChatResponse.fromJsonList(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar chats: ${response.statusCode}');
    }
  }

  @override
  Future<List<ChatResponse>> searchChats(String query) {
    // TODO: implement searchChats
    throw UnimplementedError();
  }

  Future<ChatResponse> crearChat(ChatRequest request) async {
    debugPrint('📡 Enviando: ${request.toJson()}');
    final response = await http.post(
      Uri.parse("${ApiBaseUrl.baseUrl}/chats"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
      body: jsonEncode(request.toJson()),
    );

    debugPrint('📡 Status: ${response.statusCode}'); // Debug
    debugPrint('📄 Body: ${response.body}'); 

    if (response.statusCode == 201) {
      return ChatResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error creando chat');
  }

  Future<void> eliminarChat(int chatId) async {
    final response = await http.delete(
      Uri.parse("${ApiBaseUrl.baseUrl}/chats/$chatId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error eliminando chat');
    }
  }
}
