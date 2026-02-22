class EventoResponse {
  final int id;
  final String nombre;
  final String fecha;
  final String lugar;
  final String? coordenadas;
  final String? descripcion;
  final int? aforo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BandaEvento> bandas;
  final int asistentesCount;

  EventoResponse({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.lugar,
    this.coordenadas,
    this.descripcion,
    this.aforo,
    required this.createdAt,
    required this.updatedAt,
    required this.bandas,
    required this.asistentesCount,
  });

  factory EventoResponse.fromJson(Map<String, dynamic> json) {
    return EventoResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      fecha: json['fecha'] as String? ?? '',
      lugar: json['lugar'] as String? ?? '',
      coordenadas: json['coordenadas'] as String?,
      descripcion: json['descripcion'] as String?,
      aforo: (json['aforo'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : DateTime.now(),
      bandas: (json['bandas'] as List?)
              ?.map((b) => BandaEvento.fromJson(b as Map<String, dynamic>))
              .toList() ?? [],
      asistentesCount: (json['asistentes_count'] as num?)?.toInt() ?? 0,
    );
  }

  static List<EventoResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EventoResponse.fromJson(json)).toList();
  }
}

class BandaEvento {
  final int id;
  final String nombre;
  final String? imgPerfil;

  BandaEvento({
    required this.id,
    required this.nombre,
    this.imgPerfil,
  });

  factory BandaEvento.fromJson(Map<String, dynamic> json) {
    return BandaEvento(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nombre: json['nombre'] as String? ?? '',
      imgPerfil: json['img_perfil'] as String?,
    );
  }
}