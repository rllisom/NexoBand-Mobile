class ChatRequest {
  final String? nombre;
  final int usuario1Id;  
  final int usuario2Id;  

  ChatRequest({this.nombre, required this.usuario1Id, required this.usuario2Id});

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'usuario1_id': usuario1Id,  
    'usuario2_id': usuario2Id,  
  };
}