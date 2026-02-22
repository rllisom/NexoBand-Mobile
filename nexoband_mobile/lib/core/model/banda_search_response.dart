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
      id: json['id'],
      nombre: json['nombre'],
      imgPerfil: json['img_perfil'],
      genero: json['genero'],
      descripcion: json['descripcion'],
      seguidoresCount: json['seguidores_count'] ?? 0,
    );
  }
}
