import 'package:nexoband_mobile/core/model/user_response.dart';

abstract class PerfilInterface {
  Future<UsuarioResponse> cargarPerfil();
}