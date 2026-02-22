import 'package:nexoband_mobile/core/model/user_response.dart';

class BandaMiembroResponse {
  final int id;
  final int usersId;
  final int bandasId;
  final String? rol;
  final UsuarioResponse user;

  BandaMiembroResponse({
    required this.id,
    required this.usersId,
    required this.bandasId,
    this.rol,
    required this.user,
  });

  factory BandaMiembroResponse.fromJson(Map<String, dynamic> json) {
    return BandaMiembroResponse(
      id: json['id'],
      usersId: json['users_id'],
      bandasId: json['bandas_id'],
      rol: json['rol'],
      user: UsuarioResponse.fromJson(json['user']),
    );
  }
}
