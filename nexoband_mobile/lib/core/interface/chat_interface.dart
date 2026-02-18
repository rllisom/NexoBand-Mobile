import 'package:nexoband_mobile/core/model/chat_response.dart';

abstract class ChatInterface { 
  Future<List<ChatResponse>> cargarChats();
  Future<ChatResponse> cargarChat(int chatId);
  Future<List<ChatResponse>> searchChats(String query); 
}