

import 'package:nexoband_mobile/core/dto/publicacion_request.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';

abstract class PublicacionInterface {
  Future<List<Publicacion>> listarPublicacionesUsuario();
  Future<Publicacion> crearPublicacion(PublicacionRequest request);
  Future<Publicacion> verDetallePublicacion(int publicacionId);
  Future<void> eliminarPublicacion(int publicacionId);
}