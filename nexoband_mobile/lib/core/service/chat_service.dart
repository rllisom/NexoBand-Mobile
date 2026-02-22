
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/chat_interface.dart';
import 'package:nexoband_mobile/core/model/chat_response.dart';

class ChatService implements ChatInterface{


  @override
  Future<ChatResponse> cargarChat(int chatId) async {
    var response = await http.get(Uri.parse("${ApiBaseUrl.baseUrl}/chats/$chatId"),
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
        },
    ); 
    if(response.statusCode == 200){ 
      return ChatResponse.fromJson(jsonDecode(response.body)); 
      } else { 
        throw Exception('Error al cargar chat: ${response.statusCode}'); 
        }   
  }

  @override
  Future<List<ChatResponse>> cargarChats() async {
    var response = await http.get(Uri.parse("${ApiBaseUrl.baseUrl}/chats"),
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
        },
    ); 
    
    if(response.statusCode == 200){ 
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

  Future<dynamic> crearChat(int id) async {}

}