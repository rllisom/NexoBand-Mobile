class ComentarioRequest {
  final int usersId;
  final int publicacionId;
  final int? bandasId;
  final String? contenidoTexto;

  ComentarioRequest({
    required this.usersId,
    required this.publicacionId,
    this.bandasId,
    this.contenidoTexto,
  });

  Map<String, dynamic> toJson() {
    return {
      'users_id': usersId,
      'publicacion_id': publicacionId,
      'bandas_id': bandasId,
      'contenidoTexto': contenidoTexto,
    };
  }

  factory ComentarioRequest.fromJson(Map<String, dynamic> json) {
    return ComentarioRequest(
      usersId: json['users_id'] as int,
      publicacionId: json['publicacion_id'] as int,
      bandasId: json['bandas_id'] as int?,
      contenidoTexto: json['contenidoTexto'] as String?,
    );
  }
}