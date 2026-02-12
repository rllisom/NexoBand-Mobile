class ChatResponse {
  final int id;
  final String nombre;
  final int usuario1Id;
  final int usuario2Id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Mensaje> mensajes;
  final Usuario usuario1;
  final Usuario usuario2;

  ChatResponse({
    required this.id,
    required this.nombre,
    required this.usuario1Id,
    required this.usuario2Id,
    required this.createdAt,
    required this.updatedAt,
    required this.mensajes,
    required this.usuario1,
    required this.usuario2,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      id: json['id'],
      nombre: json['nombre'],
      usuario1Id: json['usuario1_id'],
      usuario2Id: json['usuario2_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      mensajes: (json['mensajes'] as List?)
          ?.map((m) => Mensaje.fromJson(m))
          .toList() ?? [],
      usuario1: Usuario.fromJson(json['usuario1']),
      usuario2: Usuario.fromJson(json['usuario2']),
    );
  }

  static List<ChatResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChatResponse.fromJson(json)).toList();
  }
}

class Mensaje {
  final int id;
  final String texto;
  final int chatsId;
  final int usersId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Mensaje({
    required this.id,
    required this.texto,
    required this.chatsId,
    required this.usersId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      id: json['id'],
      texto: json['texto'],
      chatsId: json['chats_id'],
      usersId: json['users_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Usuario {
  final int id;
  final String username;
  final String? imgPerfil;

  Usuario({
    required this.id,
    required this.username,
    this.imgPerfil,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'],
      imgPerfil: json['img_perfil'],
    );
  }
}