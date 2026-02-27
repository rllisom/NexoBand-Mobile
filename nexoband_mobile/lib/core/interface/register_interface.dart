import '../dto/register_request.dart';

abstract class RegisterInterface {
  Future<Map<String, dynamic>> register(RegisterRequest request);
}