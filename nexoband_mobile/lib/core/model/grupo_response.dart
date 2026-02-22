class GrupoResponse {
  final int id;
  final String nombre;
  final String categoria;
  final String? icono;

  GrupoResponse({
    required this.id,
    required this.nombre,
    required this.categoria,
    this.icono,
  });

  factory GrupoResponse.fromJson(Map<String, dynamic> json) {
    return GrupoResponse(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      icono: json['icono'],
    );
  }
}
