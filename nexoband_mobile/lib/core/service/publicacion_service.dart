
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoband_mobile/config/api_base_url.dart';
import 'package:nexoband_mobile/config/guardar_token.dart';
import 'package:nexoband_mobile/core/dto/publicacion_request.dart';
import 'package:nexoband_mobile/core/interface/publicacion_interface.dart';
import 'package:nexoband_mobile/core/model/publicacion_list_response.dart';


class PublicacionService implements PublicacionInterface{
  @override
  Future<List<Publicacion>> listarPublicacionesUsuario() async{


      var response = await http.get(Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/usuario'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
        },
      );

      if(response.statusCode >= 200 && response.statusCode < 300){
        final publicacionesResponse = PublicacionListResponse.fromJson(jsonDecode(response.body));
        return publicacionesResponse.publicaciones;
      }
      else{
        throw Exception('Error al listar publicaciones: ${response.statusCode} - ${response.reasonPhrase}');
      }
    }
    
      @override
      Future<Publicacion> crearPublicacion(PublicacionRequest request) async{
      var response = await http.post(Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
        },
        body: jsonEncode(request.toJson()),
      );

      if(response.statusCode >= 200 && response.statusCode < 300){
        return Publicacion.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al crear publicación: ${response.statusCode} - ${response.reasonPhrase}');
      }
    }

      @override
      Future<void> eliminarPublicacion(int publicacionId) async{
        var response = await http.delete(Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/$publicacionId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
        },
        );

        if(response.statusCode >= 200 && response.statusCode < 300){
          return;
        } else {
          throw Exception('Error al eliminar publicación: ${response.statusCode} - ${response.reasonPhrase}');
        }
      }
    
      @override
      Future<Publicacion> verDetallePublicacion(int publicacionId) async {
        var response = await http.get(Uri.parse('${ApiBaseUrl.baseUrl}/publicaciones/$publicacionId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await GuardarToken.getAuthToken()}',
        },
        );

        if(response.statusCode >= 200 && response.statusCode < 300){
          return Publicacion.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Error al obtener detalle de publicación: ${response.statusCode} - ${response.reasonPhrase}');
        }
      }
}