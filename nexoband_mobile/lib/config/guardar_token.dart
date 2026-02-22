

import 'package:shared_preferences/shared_preferences.dart';

class GuardarToken {

  static Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No se encontró el token de autenticación.');
    }
    return token;
  }


  static Future<int> getUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (id == null) {
      throw Exception('No se encontró el id del usuario.');
    }
    return id;
  }


  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
  }
}