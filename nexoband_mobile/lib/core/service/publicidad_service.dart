
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/interface/publicidad_interfaz.dart';
import 'package:nexoband_mobile/core/model/publicidad.dart';


class PublicidadService implements PublicidadInterfaz {
  @override
  Future<List<Publicidad>> listarPublicidad() async {
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/publicidades'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
      },
    );

    debugPrint('[Publicidad] URL: ${ApiBaseUrl.baseUrl}/publicidades');
    debugPrint('[Publicidad] Status: ${response.statusCode}');
    debugPrint('[Publicidad] Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      debugPrint('[Publicidad] Items recibidos: ${decoded.length}');
      final lista = (decoded as List).map((e) => Publicidad.fromJson(e as Map<String, dynamic>)).toList();
      debugPrint('[Publicidad] Items parseados: ${lista.length}');
      for (final p in lista) {
        debugPrint('[Publicidad] -> ${p.nombreEmpresa} | estado=${p.estado} | activo=${p.estaActivo} | inicio=${p.fechaInicio} | fin=${p.fechaFinal}');
      }
      return lista;
    }
    throw Exception(
      'Error al cargar las publicidades: ${response.statusCode} - ${response.reasonPhrase}',
    );
  }

}