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
    String? imgPerfilUrl;

    if (json['img_perfil'] != null) {
      final raw = json['img_perfil'] as String;
      final filename = raw.split('/').last;
      if (filename.isNotEmpty) {
        imgPerfilUrl = 'http://10.0.2.2:8000/storage/perfiles/$filename';
      }
    }

    return UsuarioResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      apellidos: json['apellidos'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      imgPerfil: imgPerfilUrl,  
      descripcion: json['descripcion'] as String?,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      provincia: json['provincia'] as String?,
      nacionalidad: json['nacionalidad'] as String?,
      rol: json['rol'] as String? ?? '',
      instrumentos: (json['instrumentos'] as List? ?? [])
          .map((i) => InstrumentoResponse.fromJson(i as Map<String, dynamic>))
          .toList(),
      publicaciones: (json['publicaciones'] as List? ?? [])
          .map((p) => Publicacion.fromJson(p as Map<String, dynamic>))
          .toList(),
      bandas: (json['bandas'] as List? ?? [])
          .map((b) => BandaEnUsuarioResponse.fromJson(b as Map<String, dynamic>))
          .toList(),
      seguidores: (json['seguidores'] as List? ?? [])
          .map((s) => SeguidorResponse.fromJson(s as Map<String, dynamic>))
          .toList(),
      seguidos: (json['seguidos'] as List? ?? [])
          .map((s) => SeguidorResponse.fromJson(s as Map<String, dynamic>))
          .toList(),
      seguidoresCount: (json['seguidores_count'] as num?)?.toInt() ?? 0,
      seguidosCount: (json['seguidos_count'] as num?)?.toInt() ?? 0,
      bandasSeguidasCount: (json['bandas_seguidas_count'] as num?)?.toInt() ?? 0,
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
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      nivel: json['nivel'] as String?,
      experiencia: json['experiencia']?.toString(),
    );
  }
}

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
    String? imgPerfilUrl;

    if (json['img_perfil'] != null) {
      final raw = json['img_perfil'] as String;
      final filename = raw.split('/').last;
      if (filename.isNotEmpty) {
        imgPerfilUrl = 'http://10.0.2.2:8000/storage/perfiles/$filename';
      }
    }

    return SeguidorResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      apellidos: json['apellidos'] as String? ?? '',
      username: json['username'] as String? ?? '',
      imgPerfil: imgPerfilUrl,
    );
  }

}
