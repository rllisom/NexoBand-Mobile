import 'package:shared_preferences/shared_preferences.dart';

class GuardarToken {
  static Future<String> getAuthToken() async{
    final prefs = await SharedPreferences.getInstance();
    final tokens = prefs.getString('auth_token');
    if (tokens == null) {
    throw Exception('No se encontró el token de autenticación.');
    }
    return tokens;
  }
}