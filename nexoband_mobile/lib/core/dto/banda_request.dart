import 'dart:io';

class BandaRequest {
  final String nombre;
  final String? genero;
  final String? fecCreacion;
  final String? descripcion;
  final File? imgPerfil;

  BandaRequest({
    required this.nombre,
    this.genero,
    this.fecCreacion,
    this.descripcion,
    this.imgPerfil,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'genero': genero,
      'fecCreacion': fecCreacion,
      'descripcion': descripcion,
    };
  }
}