class Publicacion {
  final int id;
  final String? titulo;
  final String? contenido;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final Banda? banda;
  final Multimedia? multimedia;
  final List<Comentario> comentarios;

  Publicacion({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.banda,
    this.multimedia,
    required this.comentarios,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {

    return Publicacion(
      id:         (json['id'] as num?)?.toInt() ?? 0,
      titulo:     json['titulo'] as String?,
      contenido:  json['contenido'] as String?,
      createdAt:  json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt:  json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      user:       json['user']       != null ? User.fromJson(json['user'] as Map<String, dynamic>)            : null,
      banda:      json['banda']      != null ? Banda.fromJson(json['banda'] as Map<String, dynamic>)          : null,
      multimedia: json['multimedia'] != null ? Multimedia.fromJson(json['multimedia'] as Map<String, dynamic>): null,
      comentarios: (json['comentarios'] as List?)
              ?.map((c) => Comentario.fromJson(c as Map<String, dynamic>))
              .toList() ?? [],
    );
  }
}

class User {
  final int id;
  final String nombre;
  final String apellidos;
  final String username;
  final String? imgPerfil;

  User({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.username,
    this.imgPerfil,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String? imgPerfilUrl;
    if (json['img_perfil'] != null) {
      final raw = json['img_perfil'] as String;
      final filename = raw.split('/').last;
      if (filename.isNotEmpty) {
        imgPerfilUrl = 'http://10.0.2.2:8000/storage/perfiles/$filename';
      }
    }
    return User(
      id:        (json['id'] as num?)?.toInt() ?? 0,
      nombre:    json['nombre']    ?? '',
      apellidos: json['apellidos'] ?? '',
      username:  json['username']  ?? '',
      imgPerfil: imgPerfilUrl,
    );
  }
}

class Banda {
  final int? id;
  final String nombre;
  final String? imgPerfil;

  Banda({
    required this.id,
    required this.nombre,
    this.imgPerfil,
  });

  factory Banda.fromJson(Map<String, dynamic> json) {
    return Banda(
      id:        (json['id'] as num?)?.toInt(),
      nombre:    json['nombre']    ?? '',
      imgPerfil: json['img_perfil'] as String?,
    );
  }
}

class Multimedia {
  final int id;
  final String archivo;
  final String tipo;
  final String url;
  final DateTime createdAt;

  Multimedia({
    required this.id,
    required this.archivo,
    required this.tipo,
    required this.url,
    required this.createdAt,
  });

  factory Multimedia.fromJson(Map<String, dynamic> json) {
    String buildUrl(String? raw) {
      if (raw == null || raw.isEmpty) return '';
      if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
      final clean = raw.replaceAll(RegExp(r'^/+'), '');
      return 'http://10.0.2.2:8000/storage/$clean';
    }

    final rawUrl     = json['url']     as String?;
    final rawArchivo = json['archivo'] as String?;

    return Multimedia(
      id:        (json['id'] as num?)?.toInt() ?? 0,
      archivo:   rawArchivo ?? '',
      tipo:      json['tipo'] ?? '',
      url:       buildUrl(rawUrl ?? rawArchivo),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

class Comentario {
  final int id;
  final int usersId;
  final int publicacionId;
  final int? bandasId;
  final String contenidoTexto;
  final DateTime createdAt;

  Comentario({
    required this.id,
    required this.usersId,
    required this.publicacionId,
    this.bandasId,
    required this.contenidoTexto,
    required this.createdAt,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id:             (json['id'] as num?)?.toInt() ?? 0,
      usersId:        (json['users_id'] as num?)?.toInt() ?? 0,
      publicacionId:  (json['publicacion_id'] as num?)?.toInt() ?? 0,
      bandasId:       (json['bandas_id'] as num?)?.toInt(),
      contenidoTexto: (json['contenidoTexto'] ?? json['contenido_texto'] ?? '') as String,
      createdAt:      json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}
