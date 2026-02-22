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
      id: json['id'],
      nombre: json['nombre'],
      fecha: json['fecha'],
      lugar: json['lugar'],
      coordenadas: json['coordenadas'],
      descripcion: json['descripcion'],
      aforo: json['aforo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      bandas: (json['bandas'] as List?)
              ?.map((b) => BandaEvento.fromJson(b))
              .toList() ?? [],
      asistentesCount: json['asistentes_count'] ?? 0,
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
      id: json['id'],
      nombre: json['nombre'],
      imgPerfil: json['img_perfil'],
    );
  }
}