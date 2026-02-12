import 'package:shared_preferences/shared_preferences.dart';

class ObtenerUsuarioRegistrado {
  
  static Future<int> getUserId() async{
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) {
    throw Exception('No se encontró el ID de usuario.');
    }
    return userId;
  }
}