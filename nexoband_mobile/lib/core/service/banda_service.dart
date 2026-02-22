
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
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
}