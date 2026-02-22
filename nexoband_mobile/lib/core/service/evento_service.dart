import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/evento_request.dart';
import 'package:nexoband_mobile/core/interface/evento_interface.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';

class EventoService implements EventoInterface {
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
    } else {
      throw Exception('Error al cargar eventos: ${response.statusCode}');
    }
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
    body: jsonEncode(dto.toJson()), // ← limpio
  );

  if (response.statusCode == 201) {
    return EventoResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Error al crear evento: ${response.statusCode}');
  }
}
}
