
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/banda_request.dart';
import 'package:nexoband_mobile/core/interface/banda_interfaz.dart';
import 'package:nexoband_mobile/core/model/banda_response.dart';


class BandaService implements BandaInterfaz {
  
  @override
  Future<BandaResponse> getBandaDetail(int bandaId) async {
    
    var response = await http.get(Uri.parse('${ApiBaseUrl.baseUrl}/bandas/$bandaId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GuardarToken.getAuthToken()}',
      },
    );
    if (response.statusCode == 200) {
      return BandaResponse.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(response.body) as Map<String, dynamic>,
        ),
      );
    } else {
      throw Exception('Error al cargar los detalles de la banda');
    }
  }

  Future<void> crearBanda(BandaRequest? request) async {
      final uri = Uri.parse('${ApiBaseUrl.baseUrl}/bandas');
    
    var multipartRequest = http.MultipartRequest('POST', uri);
    
    // Headers
    multipartRequest.headers.addAll({
      'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
    });

    // Campos texto
    multipartRequest.fields['nombre'] = request!.nombre;
    if (request.genero != null) multipartRequest.fields['genero'] = request.genero!;
    if (request.descripcion != null) multipartRequest.fields['descripcion'] = request.descripcion!;
    if (request.fecCreacion != null) multipartRequest.fields['fec_creacion'] = request.fecCreacion!;

    // Imagen
    if (request.imgPerfil != null) {
      multipartRequest.files.add(
        await http.MultipartFile.fromPath(
          'img_perfil',
          request.imgPerfil!.path,
          contentType: http.MediaType('image', 'jpeg'),
        ),
      );
    }

    final response = await multipartRequest.send();
    
    if (response.statusCode == 201) {
      // Banda creada exitosamente
      return;
    } else {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Error ${response.statusCode}: $responseBody');
    }
  }

    
  }
