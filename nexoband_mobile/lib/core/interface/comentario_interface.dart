import 'package:nexoband_mobile/core/dto/comentario_request.dart';

abstract class ComentarioInterface {
  Future<void> crearComentario(ComentarioRequest request);
}