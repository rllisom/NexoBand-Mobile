import 'package:nexoband_mobile/core/model/grupo_response.dart';

class BandaEnUsuarioResponse {
  final int id;
  final String nombre;
  final String descripcion;
  final String? imgPerfil;
  final String? rol;
  final List<GrupoResponse> grupos;

  BandaEnUsuarioResponse({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.imgPerfil,
    this.rol,
    required this.grupos,
  });

  factory BandaEnUsuarioResponse.fromJson(Map<String, dynamic> json) {
    String? imgPerfilUrl;
    final raw = (json['imagen'] ?? json['img_perfil']) as String?;
    if (raw != null && raw.isNotEmpty) {
      final filename = raw.split('/').last;
      if (filename.isNotEmpty) {
        imgPerfilUrl = 'http://10.0.2.2:8000/storage/bandas/$filename';
      }
    }
    return BandaEnUsuarioResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      imgPerfil: imgPerfilUrl,
      rol: json['rol'] as String?,
      grupos: (json['grupos'] as List<dynamic>? ?? [])
          .map((g) => GrupoResponse.fromJson(g as Map<String, dynamic>))
          .toList(),
    );
  }

}
