import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/core/interface/register_interface.dart';
import '../dto/register_request.dart';



class RegisterService implements RegisterInterface {

  @override
  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final body = jsonDecode(response.body);
      if (body['errors'] != null) {
        final errors = body['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first as List<dynamic>;
        throw Exception(firstError.first.toString());
      }
      throw Exception(body['message'] ?? 'Error al registrar el usuario');
    }
  }
}
