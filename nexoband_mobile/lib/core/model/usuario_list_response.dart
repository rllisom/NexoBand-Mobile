class UsuarioListResponse {
  final int id;
  final String nombre;
  final String apellidos;
  final String username;
  final String? imgPerfil;
  final String? provincia;
  final String rol;
  final int seguidoresCount;
  final int seguidosCount;

  UsuarioListResponse({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.username,
    this.imgPerfil,
    this.provincia,
    required this.rol,
    required this.seguidoresCount,
    required this.seguidosCount,
  });

  factory UsuarioListResponse.fromJson(Map<String, dynamic> json) {
    return UsuarioListResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      apellidos: json['apellidos'] as String? ?? '',
      username: json['username'] as String? ?? '',
      imgPerfil: json['img_perfil'] as String?,
      provincia: json['provincia'] as String?,
      rol: json['rol'] as String? ?? '',
      seguidoresCount: (json['seguidores_count'] as num?)?.toInt() ?? 0,
      seguidosCount: (json['seguidos_count'] as num?)?.toInt() ?? 0,
    );
  }
}
