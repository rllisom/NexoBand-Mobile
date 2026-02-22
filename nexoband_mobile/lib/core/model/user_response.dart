import 'package:nexoband_mobile/core/model/banda_en_usuario_response.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';

class UsuarioResponse {
  final int id;
  final String nombre;
  final String apellidos;
  final String username;
  final String email;
  final String? imgPerfil;
  final String? descripcion;
  final String? telefono;
  final String? direccion;
  final String? provincia;
  final String? nacionalidad;
  final String rol;
  final List<InstrumentoResponse> instrumentos;
  final List<Publicacion> publicaciones;
  final List<BandaEnUsuarioResponse> bandas;
  final List<SeguidorResponse> seguidores;  
  final List<SeguidorResponse> seguidos;    
  final int seguidoresCount;
  final int seguidosCount;
  final int bandasSeguidasCount;

  UsuarioResponse({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.username,
    required this.email,
    this.imgPerfil,
    this.descripcion,
    this.telefono,
    this.direccion,
    this.provincia,
    this.nacionalidad,
    required this.rol,
    required this.instrumentos,
    required this.publicaciones,
    required this.bandas,
    required this.seguidores,   
    required this.seguidos,     
    required this.seguidoresCount,
    required this.seguidosCount,
    required this.bandasSeguidasCount,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) {
    return UsuarioResponse(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      username: json['username'],
      email: json['email'],
      imgPerfil: json['img_perfil'],
      descripcion: json['descripcion'],
      telefono: json['telefono'],
      direccion: json['direccion'],
      provincia: json['provincia'],
      nacionalidad: json['nacionalidad'],
      rol: json['rol'],
      instrumentos: (json['instrumentos'] as List? ?? [])
          .map((i) => InstrumentoResponse.fromJson(i))
          .toList(),
      publicaciones: (json['publicaciones'] as List? ?? [])
          .map((p) => Publicacion.fromJson(p))
          .toList(),
      bandas: (json['bandas'] as List? ?? [])
          .map((b) => BandaEnUsuarioResponse.fromJson(b))
          .toList(),
      seguidores: (json['seguidores'] as List? ?? [])   
          .map((s) => SeguidorResponse.fromJson(s))
          .toList(),
      seguidos: (json['seguidos'] as List? ?? [])       
          .map((s) => SeguidorResponse.fromJson(s))
          .toList(),
      seguidoresCount: json['seguidores_count'] ?? 0,
      seguidosCount: json['seguidos_count'] ?? 0,
      bandasSeguidasCount: json['bandas_seguidas_count'] ?? 0,
    );
  }
}

class InstrumentoResponse {
  final int id;
  final String nombre;
  final String? nivel;
  final String? experiencia;

  InstrumentoResponse({
    required this.id,
    required this.nombre,
    this.nivel,
    this.experiencia,
  });

  factory InstrumentoResponse.fromJson(Map<String, dynamic> json) {
    return InstrumentoResponse(
      id: json['id'],
      nombre: json['nombre'],
      nivel: json['nivel'],
      experiencia: json['experiencia'],
    );
  }
}

// PublicacionResponse eliminada — usar Publicacion de publicacion_response.dart

class SeguidorResponse {
  final int id;
  final String nombre;
  final String apellidos;
  final String username;
  final String? imgPerfil;

  SeguidorResponse({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.username,
    this.imgPerfil,
  });

  factory SeguidorResponse.fromJson(Map<String, dynamic> json) {
    return SeguidorResponse(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      username: json['username'],
      imgPerfil: json['img_perfil'],
    );
  }
}
