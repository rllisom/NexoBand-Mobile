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
      id: (json['id'] as num?)?.toInt() ?? 0,
      usersId: (json['users_id'] as num?)?.toInt() ?? 0,
      bandasId: (json['bandas_id'] as num?)?.toInt() ?? 0,
      rol: json['rol'] as String?,
      user: UsuarioResponse.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
