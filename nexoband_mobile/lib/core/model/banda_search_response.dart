class BandaSearchResponse {
  final int id;
  final String nombre;
  final String? imgPerfil;
  final String? genero;
  final String? descripcion;
  final int seguidoresCount;

  BandaSearchResponse({
    required this.id,
    required this.nombre,
    this.imgPerfil,
    this.genero,
    this.descripcion,
    required this.seguidoresCount,
  });

  factory BandaSearchResponse.fromJson(Map<String, dynamic> json) {
    return BandaSearchResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      imgPerfil: json['img_perfil'] as String?,
      genero: json['genero'] as String?,
      descripcion: json['descripcion'] as String?,
      seguidoresCount: (json['seguidores_count'] as num?)?.toInt() ?? 0,
    );
  }
}
