import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';

class BandaResponse {
  final int id;
  final String nombre;
  final String? imgPerfil;
  final String? genero;
  final String? fecCreacion;
  final String? descripcion;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UsuarioBanda> usuarios;
  final CategoriaBanda? categoria;
  final int publicacionesCount;
  final List<EventoResponse> eventos;
  final int seguidoresCount;

  final List<Publicacion>? publicaciones;
  final List<SeguidorBanda>? seguidores;

  BandaResponse({
    required this.id,
    required this.nombre,
    this.imgPerfil,
    this.genero,
    this.fecCreacion,
    this.descripcion,
    this.createdAt,
    this.updatedAt,
    required this.usuarios,
    this.categoria,
    required this.publicacionesCount,
    required this.eventos,
    required this.seguidoresCount,
    this.publicaciones,
    this.seguidores,
  });

  factory BandaResponse.fromJson(Map<String, dynamic> json) => BandaResponse(
    id: (json['id'] as num?)?.toInt() ?? 0,
    nombre: json['nombre'] ?? '',
    imgPerfil: () {
      final raw = json['img_perfil'];
      if (raw == null) return null;
      final filename = (raw as String).split('/').last;
      if (filename.isEmpty) return null;
      return 'http://10.0.2.2:8000/storage/bandas/$filename'; // ✅ Igual que perfiles
    }(),
    genero: json['genero'],
    fecCreacion: json['fec_creacion'],
    descripcion: json['descripcion'],
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'])
        : null,
    usuarios:
        (json['usuarios'] as List?)
            ?.map((u) => UsuarioBanda.fromJson(u))
            .toList() ??
        [],
    // El backend devuelve 'categoria' como array → tomamos el primero
    categoria: () {
      final raw = json['categoria'];
      if (raw == null) return null;
      if (raw is List && raw.isNotEmpty) {
        return CategoriaBanda.fromJson(raw.first as Map<String, dynamic>);
      }
      if (raw is Map<String, dynamic>) return CategoriaBanda.fromJson(raw);
      return null;
    }(),
    publicacionesCount:
        (json['publicaciones_count'] as num?)?.toInt() ??
        (json['publicaciones'] as List?)?.length ??
        0,
    eventos:
        (json['eventos'] as List?)
            ?.map((e) => EventoResponse.fromJson(e))
            .toList() ??
        [],
    seguidoresCount:
        (json['seguidores_count'] as num?)?.toInt() ??
        (json['seguidores'] as List?)?.length ??
        0,
    // Solo en show()
    publicaciones: (json['publicaciones'] as List?)
        ?.map((p) => Publicacion.fromJson(p))
        .toList(),
    seguidores: (json['seguidores'] as List?)
        ?.map((s) => SeguidorBanda.fromJson(s))
        .toList(),
  );

  static List<BandaResponse> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => BandaResponse.fromJson(json)).toList();
}

// ─── Miembro de la banda ──────────────────────────────────────────────
class UsuarioBanda {
  final int id;
  final String nombre;
  final String apellidos;
  final String username;
  final String? imgPerfil;
  final String? email;
  final String? telefono;
  final String? rol;

  UsuarioBanda({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.username,
    this.imgPerfil,
    this.email,
    this.telefono,
    this.rol,
  });

  factory UsuarioBanda.fromJson(Map<String, dynamic> json) {
    String? imgPerfilUrl;
    if (json['img_perfil'] != null) {
      final raw = json['img_perfil'] as String;
      final filename = raw.split('/').last;
      if (filename.isNotEmpty) {
        imgPerfilUrl =
            'http://10.0.2.2:8000/storage/perfiles/$filename'; // ✅ perfiles, no bandas
      }
    }
    return UsuarioBanda(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
      username: json['username'] ?? '',
      imgPerfil: imgPerfilUrl,
      email: json['email'],
      telefono: json['telefono'],
      rol: json['rol'],
    );
  }
}

// ─── Categoría/Grupo ─────────────────────────────────────────────────
class CategoriaBanda {
  final int id;
  final String nombre;
  final String? categoria;

  CategoriaBanda({required this.id, required this.nombre, this.categoria});

  factory CategoriaBanda.fromJson(Map<String, dynamic> json) => CategoriaBanda(
    id: (json['id'] as num?)?.toInt() ?? 0,
    nombre: json['nombre'] ?? '',
    categoria: json['categoria'],
  );
}

// ─── Evento de la banda ───────────────────────────────────────────────
class EventoBanda {
  final int id;
  final String nombre;
  final String fecha;
  final String lugar;
  final String? coordenadas;
  final String? descripcion;
  final int? aforo;

  EventoBanda({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.lugar,
    this.coordenadas,
    this.descripcion,
    this.aforo,
  });

  factory EventoBanda.fromJson(Map<String, dynamic> json) => EventoBanda(
    id: (json['id'] as num?)?.toInt() ?? 0,
    nombre: json['nombre'] ?? '',
    fecha: json['fecha'] ?? '',
    lugar: json['lugar'] ?? '',
    coordenadas: json['coordenadas'],
    descripcion: json['descripcion'],
    aforo: (json['aforo'] as num?)?.toInt(),
  );
}

// ─── Publicación de la banda (solo en show()) ─────────────────────────
class PublicacionBanda {
  final int id;
  final String? titulo;
  final String? contenido;
  final DateTime? createdAt;
  final MultimediaBanda? multimedia;
  final int comentariosCount;

  PublicacionBanda({
    required this.id,
    this.titulo,
    this.contenido,
    this.createdAt,
    this.multimedia,
    required this.comentariosCount,
  });

  factory PublicacionBanda.fromJson(Map<String, dynamic> json) =>
      PublicacionBanda(
        id: (json['id'] as num?)?.toInt() ?? 0,
        titulo: json['titulo'],
        contenido: json['contenido'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        multimedia: json['multimedia'] != null
            ? MultimediaBanda.fromJson(json['multimedia'])
            : null,
        comentariosCount: (json['comentarios_count'] as num?)?.toInt() ?? 0,
      );
}

// ─── Multimedia ───────────────────────────────────────────────────────
class MultimediaBanda {
  final int id;
  final String archivo;
  final String tipo;
  final String url;

  MultimediaBanda({
    required this.id,
    required this.archivo,
    required this.tipo,
    required this.url,
  });

  factory MultimediaBanda.fromJson(Map<String, dynamic> json) =>
      MultimediaBanda(
        id: (json['id'] as num?)?.toInt() ?? 0,
        archivo: json['archivo'] ?? '',
        tipo: json['tipo'] ?? '',
        url: json['url'] ?? '',
      );
}

// ─── Seguidor (solo en show()) ────────────────────────────────────────
class SeguidorBanda {
  final int id;
  final String nombre;
  final String apellidos;
  final String username;
  final String? imgPerfil;

  SeguidorBanda({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.username,
    this.imgPerfil,
  });

  factory SeguidorBanda.fromJson(Map<String, dynamic> json) {
    String? imgPerfilUrl;
    if (json['img_perfil'] != null) {
      final raw = json['img_perfil'] as String;
      final filename = raw.split('/').last;
      if (filename.isNotEmpty) {
        imgPerfilUrl = 'http://10.0.2.2:8000/storage/perfiles/$filename';
      }
    }
    return SeguidorBanda(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
      username: json['username'] ?? '',
      imgPerfil: imgPerfilUrl,
    );
  }
}
