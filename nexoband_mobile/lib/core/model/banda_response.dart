import 'package:nexoband_mobile/core/model/banda_miembro_response.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/core/model/grupo_response.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';

class BandaResponse {
  final int id;
  final String nombre;
  final String? imgPerfil;
  final String? genero;
  final String? fecCreacion;
  final String? descripcion;
  final List<BandaMiembroResponse> usuarios;
  final List<Publicacion> publicaciones;
  final List<GrupoResponse> grupos;
  final List<EventoResponse> eventos;

  BandaResponse({
    required this.id,
    required this.nombre,
    this.imgPerfil,
    this.genero,
    this.fecCreacion,
    this.descripcion,
    required this.usuarios,
    required this.publicaciones,
    required this.grupos,
    required this.eventos,
  });

  factory BandaResponse.fromJson(Map<String, dynamic> json) {
    final data = json['banda'] ?? json;
    return BandaResponse(
      id: data['id'],
      nombre: data['nombre'],
      imgPerfil: data['img_perfil'],
      genero: data['genero'],
      fecCreacion: data['fec_creacion'],
      descripcion: data['descripcion'],
      usuarios: (data['usuarios'] as List<dynamic>? ?? [])
          .map((u) => BandaMiembroResponse.fromJson(u))
          .toList(),
      publicaciones: (data['publicaciones'] as List<dynamic>? ?? [])
          .map((p) => Publicacion.fromJson(p))
          .toList(),
      grupos: (data['grupos'] as List<dynamic>? ?? [])
          .map((g) => GrupoResponse.fromJson(g))
          .toList(),
      eventos: (data['eventos'] as List<dynamic>? ?? [])
          .map((e) => EventoResponse.fromJson(e))
          .toList(),
    );
  }
}
