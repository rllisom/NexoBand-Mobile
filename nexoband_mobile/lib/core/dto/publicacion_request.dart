import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class PublicacionRequest {
  final String titulo;
  final String contenido;
  final int? usersId;
  final int? bandasId;

  PublicacionRequest({
    required this.titulo,
    required this.contenido,
    this.usersId,
    this.bandasId,
  });

  // 👈 Para FormData con multimedia
  Future<FormData> toFormData({XFile? archivo}) async {
    final formData = FormData.fromMap({
      'titulo': titulo,
      'contenido': contenido,
      if (usersId != null) 'users_id': usersId!,
      if (bandasId != null) 'bandas_id': bandasId!,
    });

    // 👈 Añade archivo si existe
    if (archivo != null) {
      formData.files.add(
        MapEntry(
          'archivo',
          await MultipartFile.fromFile(archivo.path),
        ),
      );
    }

    return formData;
  }

  // 👈 Versión simple sin multimedia (si la necesitas)
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'contenido': contenido,
      if (usersId != null) 'users_id': usersId!,
      if (bandasId != null) 'bandas_id': bandasId!,
    };
  }

  // 👈 Campos para http.MultipartRequest
  Map<String, String> toFields() {
    return {
      'titulo': titulo,
      'contenido': contenido,
      if (usersId != null) 'users_id': usersId!.toString(),
      if (bandasId != null) 'bandas_id': bandasId!.toString(),
    };
  }

  factory PublicacionRequest.fromJson(Map<String, dynamic> json) {
    return PublicacionRequest(
      titulo: json['titulo'] as String? ?? '',
      contenido: json['contenido'] as String? ?? '',
      usersId: json['users_id'] as int?,
      bandasId: json['bandas_id'] as int?,
    );
  }
}
