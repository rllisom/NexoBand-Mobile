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
            id: json['id'],
            titulo: json['titulo'],
            contenido: json['contenido'],
            createdAt: DateTime.parse(json['created_at']),
            updatedAt: DateTime.parse(json['updated_at']),
            user: json['user'] != null ? User.fromJson(json['user']) : null,
            banda: json['banda'] != null ? Banda.fromJson(json['banda']) : null,
            multimedia: json['multimedia'] != null ? Multimedia.fromJson(json['multimedia']) : null,
            comentarios: (json['comentarios'] as List?)?.map((c) => Comentario.fromJson(c)).toList() ?? [],
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
        return User(
            id: json['id'],
            nombre: json['nombre'],
            apellidos: json['apellidos'],
            username: json['username'],
            imgPerfil: json['img_perfil'],
        );
    }
}


class Banda {
    final int id;
    final String nombre;
    final String? imgPerfil;

    Banda({
        required this.id,
        required this.nombre,
        this.imgPerfil,
    });

    factory Banda.fromJson(Map<String, dynamic> json) {
        return Banda(
            id: json['id'],
            nombre: json['nombre'],
            imgPerfil: json['img_perfil'],
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
        return Multimedia(
            id: json['id'],
            archivo: json['archivo'],
            tipo: json['tipo'],
            url: json['url'],
            createdAt: json['created_at'] != null 
            ? DateTime.parse(json['created_at']) 
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
            id: json['id'],
            usersId: json['users_id'],
            publicacionId: json['publicacion_id'],
            bandasId: json['bandas_id'],
            contenidoTexto: json['contenidoTexto'],
            createdAt: DateTime.parse(json['created_at']),
        );
    }
}