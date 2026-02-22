import 'package:nexoband_mobile/core/model/grupo_response.dart';

class BandaEnUsuarioResponse {
  final int id;
  final String nombre;
  final String descripcion;
  final String? imagen;
  final String? rol;
  final List<GrupoResponse> grupos;

  BandaEnUsuarioResponse({
    required this.id,
    required this.nombre,
    required this.descripcion,
    this.imagen,
    this.rol,
    required this.grupos,
  });

  factory BandaEnUsuarioResponse.fromJson(Map<String, dynamic> json) {
    return BandaEnUsuarioResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      imagen: json['imagen'] as String?,
      rol: json['rol'] as String?,
      grupos: (json['grupos'] as List<dynamic>? ?? [])
          .map((g) => GrupoResponse.fromJson(g as Map<String, dynamic>))
          .toList(),
    );
  }
}
