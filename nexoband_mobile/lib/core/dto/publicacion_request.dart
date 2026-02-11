class PublicacionRequest {
  final String titulo;
  final String contenido;
  final int usersId;
  final int bandasId;

  PublicacionRequest({
    required this.titulo,
    required this.contenido,
    required this.usersId,
    required this.bandasId,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'contenido': contenido,
      'users_id': usersId,
      'bandas_id': bandasId,
    };
  }

  factory PublicacionRequest.fromJson(Map<String, dynamic> json) {
    return PublicacionRequest(
      titulo: json['titulo'] as String,
      contenido: json['contenido'] as String,
      usersId: json['users_id'] as int,
      bandasId: json['bandas_id'] as int,
    );
  }
}