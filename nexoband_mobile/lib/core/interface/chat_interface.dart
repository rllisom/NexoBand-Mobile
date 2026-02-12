import 'package:nexoband_mobile/core/model/chat_response.dart';

abstract class ChatInterface { 
  Future<List<ChatResponse>> cargarChats();
  Future<ChatResponse> cargarChat(String chatId);
  Future<List<ChatResponse>> searchChats(String query); 
}