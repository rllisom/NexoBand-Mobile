import 'dart:io';

class BandaRequest {
  final String nombre;
  final String? genero;
  final String? fecCreacion;
  final String? descripcion;
  final File? imgPerfil;
  final int? categoria; 

  BandaRequest({
    required this.nombre,
    this.genero,
    this.fecCreacion,
    this.descripcion,
    this.imgPerfil,
    this.categoria,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      if (genero != null) 'genero': genero,
      if (fecCreacion != null) 'fec_creacion': fecCreacion,
      if (descripcion != null) 'descripcion': descripcion,
      if (imgPerfil != null) 'img_perfil': imgPerfil,
      if (categoria != null) 'categoria': categoria,
    };
  }
}