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
    String? imgPerfilUrl;
    if (json['img_perfil'] != null) {
      final raw = json['img_perfil'] as String;
      final filename = raw.split('/').last;
      if (filename.isNotEmpty) {
        imgPerfilUrl = 'http://10.0.2.2:8000/storage/bandas/$filename';
      }
    }
    return BandaSearchResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      imgPerfil: imgPerfilUrl,
      genero: json['genero'] as String?,
      descripcion: json['descripcion'] as String?,
      seguidoresCount: (json['seguidores_count'] as num?)?.toInt() ?? 0,
    );
  }
}
