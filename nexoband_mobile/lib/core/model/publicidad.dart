class Publicidad {
  final String nombreEmpresa;
  final String tipoEmpresa;
  final String icono;
  final bool estado;
  final DateTime fechaInicio;
  final DateTime fechaFinal;
  final String descripcion;
  final String nombreContacto;
  final String emailContacto;
  final String telefonoContacto;
  final double precioAparicion;
  final int nApariciones;

  Publicidad({
    required this.nombreEmpresa,
    required this.tipoEmpresa,
    required this.icono,
    required this.estado,
    required this.fechaInicio,
    required this.fechaFinal,
    required this.descripcion,
    required this.nombreContacto,
    required this.emailContacto,
    required this.telefonoContacto,
    required this.precioAparicion,
    required this.nApariciones,
  });

  factory Publicidad.fromJson(Map<String, dynamic> json) {
    return Publicidad(
      nombreEmpresa: json['nombre_empresa'] ?? '',
      tipoEmpresa: json['tipo_empresa'] ?? '',
      icono: json['icono'] ?? '📢',
      estado: json['estado'] ?? true,
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'])
          : DateTime.now(),
      fechaFinal: json['fecha_final'] != null
          ? DateTime.parse(json['fecha_final'])
          : DateTime.now().add(const Duration(days: 30)),
      descripcion: json['descripcion'] ?? '',
      nombreContacto: json['nombre_contacto'] ?? '',
      emailContacto: json['email_contacto'] ?? '',
      telefonoContacto: json['telefono_contacto'] ?? '',
      precioAparicion: (json['precio_aparicion'] as num?)?.toDouble() ?? 0.0,
      nApariciones: (json['n_apariciones'] as num?)?.toInt() ?? 0,
    );
  }

  // Helper para verificar si el anuncio está activo
  bool get estaActivo {
    final ahora = DateTime.now();
    return estado && 
           ahora.isAfter(fechaInicio) && 
           ahora.isBefore(fechaFinal);
  }
}
