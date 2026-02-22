class UsuarioSearchResponse {
  final int id;
  final String nombre;
  final String apellidos;
  final String username;
  final String? imgPerfil;
  final String? descripcion;
  final List<Map<String, dynamic>> instrumentos;
  final int seguidoresCount;

  UsuarioSearchResponse({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.username,
    this.imgPerfil,
    this.descripcion,
    required this.instrumentos,
    required this.seguidoresCount,
  });

  factory UsuarioSearchResponse.fromJson(Map<String, dynamic> json) {
    return UsuarioSearchResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      apellidos: json['apellidos'] as String? ?? '',
      username: json['username'] as String? ?? '',
      imgPerfil: json['img_perfil'] as String?,
      descripcion: json['descripcion'] as String?,
      instrumentos: List<Map<String, dynamic>>.from(json['instrumentos'] ?? []),
      seguidoresCount: (json['seguidores_count'] as num?)?.toInt() ?? 0,
    );
  }
}
