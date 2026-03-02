import 'package:nexoband_mobile/core/model/user_response.dart';

abstract class InstrumentoInterfaz {
  Future<List<InstrumentoResponse>> listarTodos();
  Future<void> agregarAUsuario(int usuarioId, int instrumentoId);
  Future<void> eliminarDeUsuario(int usuarioId, int instrumentoId);
}