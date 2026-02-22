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
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      username: json['username'],
      imgPerfil: json['img_perfil'],
      provincia: json['provincia'],
      rol: json['rol'],
      seguidoresCount: json['seguidores_count'] ?? 0,
      seguidosCount: json['seguidos_count'] ?? 0,
    );
  }
}
