class ChatResponse {
  final int id;
  final String? nombre;
  final int usuario1Id;
  final int usuario2Id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Mensaje> mensajes;
  final Usuario usuario1;
  final Usuario usuario2;

  ChatResponse({
    required this.id,
    this.nombre,
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
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String?,
      usuario1Id: (json['usuario1_id'] as num?)?.toInt() ?? 0,
      usuario2Id: (json['usuario2_id'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : DateTime.now(),
      mensajes: (json['mensajes'] as List?)
          ?.map((m) => Mensaje.fromJson(m as Map<String, dynamic>))
          .toList() ?? [],
      usuario1: json['usuario1'] != null ? Usuario.fromJson(json['usuario1'] as Map<String, dynamic>) : Usuario(id: 0),
      usuario2: json['usuario2'] != null ? Usuario.fromJson(json['usuario2'] as Map<String, dynamic>) : Usuario(id: 0),
    );
  }

  static List<ChatResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChatResponse.fromJson(json)).toList();
  }
}

class Mensaje {
  final int id;
  final String? texto;
  final int chatsId;
  final int usersId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Mensaje({
    required this.id,
    this.texto,
    required this.chatsId,
    required this.usersId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      id: (json['id'] as num?)?.toInt() ?? 0,
      texto: json['texto'] as String?,
      chatsId: (json['chats_id'] as num?)?.toInt() ?? 0,
      usersId: (json['users_id'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : DateTime.now(),
    );
  }
}

class Usuario {
  final int id;
  final String? username;
  final String? imgPerfil;

  Usuario({
    required this.id,
    this.username,
    this.imgPerfil,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username'] as String?,
      imgPerfil: json['img_perfil'] as String?,
    );
  }
}