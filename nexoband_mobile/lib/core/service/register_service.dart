import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/core/interface/register_interface.dart';
import '../dto/register_request.dart';

class RegisterService implements RegisterInterface {

  static String _traducirError(String campo, String mensaje) {
    final m = mensaje.toLowerCase();
    switch (campo) {
      case 'username':
        if (m.contains('already been taken') || m.contains('unique')) {
          return 'El nombre de usuario ya está en uso';
        }
        if (m.contains('required')) return 'El nombre de usuario es obligatorio';
        if (m.contains('max')) return 'El nombre de usuario es demasiado largo';
        return 'Nombre de usuario no válido';
      case 'email':
        if (m.contains('already been taken') || m.contains('unique')) {
          return 'El correo electrónico ya está registrado';
        }
        if (m.contains('required')) return 'El correo electrónico es obligatorio';
        if (m.contains('valid email') || m.contains('email')) {
          return 'El formato del correo no es válido';
        }
        return 'Correo electrónico no válido';
      case 'password':
        if (m.contains('confirmation') || m.contains('confirmed')) {
          return 'Las contraseñas no coinciden';
        }
        if (m.contains('required')) return 'La contraseña es obligatoria';
        if (m.contains('min') || m.contains('at least')) {
          return 'La contraseña debe tener al menos 8 caracteres';
        }
        return 'Contraseña no válida';
      case 'password_confirmation':
        return 'Las contraseñas no coinciden';
      case 'nombre':
        if (m.contains('required')) return 'El nombre es obligatorio';
        return 'Nombre no válido';
      case 'apellidos':
        if (m.contains('required')) return 'Los apellidos son obligatorios';
        return 'Apellidos no válidos';
      case 'telefono':
        if (m.contains('required')) return 'El teléfono es obligatorio';
        return 'Teléfono no válido';
      default:
        return mensaje;
    }
  }

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
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (body['errors'] != null) {
      final errors = body['errors'] as Map<String, dynamic>;
      final mensajes = errors.entries.expand((entry) {
        final campo = entry.key;
        final lista = entry.value as List<dynamic>;
        return lista.map((e) => _traducirError(campo, e.toString()));
      }).toList();
      throw Exception(mensajes.join('\n'));
    }

    switch (response.statusCode) {
      case 400:
        throw Exception(body['message'] ?? 'La solicitud no es válida');
      case 409:
        throw Exception('Ya existe una cuenta con esos datos');
      case 422:
        throw Exception(body['message'] ?? 'Datos de registro no válidos');
      case 500:
        throw Exception('Error interno del servidor. Inténtalo más tarde');
      default:
        throw Exception(body['message'] ?? 'Error al registrar el usuario');
    }
  }
}
