class AuthSessionResponse {
  final String token;
  final User user;

  AuthSessionResponse({
    required this.token,
    required this.user,
  });

  factory AuthSessionResponse.fromJson(Map<String, dynamic> json) {
    return AuthSessionResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String nombre;
  final String apellidos;
  final String username;
  final String email;
  final String imgPerfil;
  final String descripcion;
  final String telefono;
  final String direccion;
  final String provincia;
  final String nacionalidad;
  final String rol;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Instrumento> instrumentos;
  final List<Banda> bandas;
  final int publicacionesCount;
  final int comentariosCount;
  final int eventosCount;
  final int seguidoresCount;
  final int seguidosCount;
  final int bandasSeguidas;
  final int likesCount;

  User({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.username,
    required this.email,
    required this.imgPerfil,
    required this.descripcion,
    required this.telefono,
    required this.direccion,
    required this.provincia,
    required this.nacionalidad,
    required this.rol,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.instrumentos,
    required this.bandas,
    required this.publicacionesCount,
    required this.comentariosCount,
    required this.eventosCount,
    required this.seguidoresCount,
    required this.seguidosCount,
    required this.bandasSeguidas,
    required this.likesCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      apellidos: json['apellidos'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      imgPerfil: json['img_perfil'] as String,
      descripcion: json['descripcion'] as String,
      telefono: json['telefono'] as String,
      direccion: json['direccion'] as String,
      provincia: json['provincia'] as String,
      nacionalidad: json['nacionalidad'] as String,
      rol: json['rol'] as String,
      estado: json['estado'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      instrumentos: (json['instrumentos'] as List).map((i) => Instrumento.fromJson(i)).toList(),
      bandas: (json['bandas'] as List).map((b) => Banda.fromJson(b)).toList(),
      publicacionesCount: json['publicaciones_count'] as int,
      comentariosCount: json['comentarios_count'] as int,
      eventosCount: json['eventos_count'] as int,
      seguidoresCount: json['seguidores_count'] as int,
      seguidosCount: json['seguidos_count'] as int,
      bandasSeguidas: json['bandas_seguidas_count'] as int,
      likesCount: json['likes_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'username': username,
      'email': email,
      'img_perfil': imgPerfil,
      'descripcion': descripcion,
      'telefono': telefono,
      'direccion': direccion,
      'provincia': provincia,
      'nacionalidad': nacionalidad,
      'rol': rol,
      'estado': estado,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'instrumentos': instrumentos.map((i) => i.toJson()).toList(),
      'bandas': bandas.map((b) => b.toJson()).toList(),
      'publicaciones_count': publicacionesCount,
      'comentarios_count': comentariosCount,
      'eventos_count': eventosCount,
      'seguidores_count': seguidoresCount,
      'seguidos_count': seguidosCount,
      'bandas_seguidas_count': bandasSeguidas,
      'likes_count': likesCount,
    };
  }
}

class Instrumento {
  final int id;
  final String nombre;
  final String nivel;
  final int experiencia;
  final String descripcion;
  final String generos;

  Instrumento({
    required this.id,
    required this.nombre,
    required this.nivel,
    required this.experiencia,
    required this.descripcion,
    required this.generos,
  });

  factory Instrumento.fromJson(Map<String, dynamic> json) {
    return Instrumento(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      nivel: json['nivel'] as String,
      experiencia: json['experiencia'] as int,
      descripcion: json['descripcion'] as String,
      generos: json['generos'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'nivel': nivel,
      'experiencia': experiencia,
      'descripcion': descripcion,
      'generos': generos,
    };
  }
}

class Banda {
  final int id;
  final String nombre;
  final String rol;

  Banda({
    required this.id,
    required this.nombre,
    required this.rol,
  });

  factory Banda.fromJson(Map<String, dynamic> json) {
    return Banda(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      rol: json['rol'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'rol': rol,
    };
  }
}