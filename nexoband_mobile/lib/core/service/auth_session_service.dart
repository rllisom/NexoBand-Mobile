
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/core/dto/login_request.dart';
import 'package:nexoband_mobile/core/interface/auth_session_interface.dart';
import 'package:nexoband_mobile/core/model/auth_session_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSessionService implements AuthSessionInterface{
  @override
  Future<AuthSessionResponse> iniciarSesion(LoginRequest request) async {
    final url = '${ApiBaseUrl.baseUrl}/auth/login';
    print('Intentando conectar a: $url');
    
    var response = await http.post(Uri.parse(url),
      body: jsonEncode(request.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    try{
      if(response.statusCode >= 200 && response.statusCode < 300){
        final authSessionResponse = AuthSessionResponse.fromJson(jsonDecode(response.body));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', authSessionResponse.token);
        return authSessionResponse;
      }
      else{
        throw Exception('Error al iniciar sesión: ${response.statusCode} - ${response.reasonPhrase}');
      }

    }catch(e){
      throw Exception('Error al iniciar sesión: $e');
    }
  
  }
}