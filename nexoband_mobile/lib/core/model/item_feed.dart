import 'package:nexoband_mobile/core/model/publicacion_response.dart';
import 'package:nexoband_mobile/core/model/publicidad.dart';

/// Clase que representa un item en el feed (puede ser publicación o publicidad)
class ItemFeed {
  final Publicacion? publicacion;
  final Publicidad? publicidad;

  ItemFeed.publicacion(this.publicacion) : publicidad = null;
  ItemFeed.publicidad(this.publicidad) : publicacion = null;

  bool get esPublicacion => publicacion != null;
  bool get esPublicidad => publicidad != null;
}
