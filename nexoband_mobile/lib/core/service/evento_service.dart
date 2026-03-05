import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/evento_request.dart';
import 'package:nexoband_mobile/core/interface/evento_interface.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';

class EventoService implements EventoInterface {

  static String _mensajeError(int statusCode, String operacion, [Map<String, dynamic>? body]) {
    switch (statusCode) {
      case 400: return body?['message'] ?? 'La solicitud no es válida';
      case 401: return 'Sesión expirada. Vuelve a iniciar sesión';
      case 403: return 'No tienes permiso para realizar esta acción';
      case 404: return 'El evento no existe o fue eliminado';
      case 422: return body?['message'] ?? 'Datos del evento no válidos';
      case 500: return 'Error interno del servidor. Inténtalo más tarde';
      default:  return 'Error al $operacion (código $statusCode)';
    }
  }

  static Map<String, dynamic>? _parseBody(String body) {
    try { return jsonDecode(body) as Map<String, dynamic>?; } catch (_) { return null; }
  }
  @override
  Future<List<EventoResponse>> cargarEventos({bool soloProximos = true}) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/eventos').replace(
      queryParameters: soloProximos ? {'proximos': '1'} : null,
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return EventoResponse.fromJsonList(data['eventos']);
    }
    throw Exception(_mensajeError(response.statusCode, 'cargar los eventos', _parseBody(response.body)));
  }

  @override
  Future<EventoResponse> crearEvento(EventoRequest dto) async {
    
  final response = await http.post(
    Uri.parse('${ApiBaseUrl.baseUrl}/eventos'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
    },
    body: jsonEncode(dto.toJson()),
  );

  if (response.statusCode == 201) {
    return EventoResponse.fromJson(jsonDecode(response.body));
  }
  throw Exception(_mensajeError(response.statusCode, 'crear el evento', _parseBody(response.body)));
}

  @override
  Future<void> eliminarEvento(int eventoId) async {
    final response = await http.delete(
      Uri.parse('${ApiBaseUrl.baseUrl}/eventos/$eventoId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(_mensajeError(response.statusCode, 'eliminar el evento', _parseBody(response.body)));
    }
  }

  @override
  Future<void> agregarBanda(int eventoId, int bandaId) async {
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/eventos/${eventoId}/bandas'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
      body: jsonEncode({'bandas_id': bandaId}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(_mensajeError(response.statusCode, 'agregar la banda al evento', _parseBody(response.body)));
    }
  }
}
