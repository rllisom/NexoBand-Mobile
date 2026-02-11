
import 'package:nexoband_mobile/core/dto/login_request.dart';
import 'package:nexoband_mobile/core/model/auth_session_response.dart';

abstract class AuthSessionInterface {
  Future<AuthSessionResponse> iniciarSesion(LoginRequest request);  
}