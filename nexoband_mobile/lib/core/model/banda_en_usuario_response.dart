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
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'],
      rol: json['rol'],
      grupos: (json['grupos'] as List<dynamic>? ?? [])
          .map((g) => GrupoResponse.fromJson(g))
          .toList(),
    );
  }
}
