class EventoRequest {
  final String nombre;
  final String fecha; 
  final String lugar;
  final String? coordenadas;
  final String? descripcion;
  final int? aforo;
  final int bandasId;

  EventoRequest({
    required this.nombre,
    required this.fecha,
    required this.lugar,
    this.coordenadas,
    this.descripcion,
    this.aforo,
    required this.bandasId,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'fecha': fecha,
      'lugar': lugar,
      'coordenadas': coordenadas,
      'descripcion': descripcion,
      'aforo': aforo,
      'bandas_id': bandasId,
    };
  }
}