import 'package:nexoband_mobile/core/dto/evento_request.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';

abstract class EventoInterface {
  Future<List<EventoResponse>> cargarEventos({bool soloProximos = true});
  Future<EventoResponse> crearEvento(EventoRequest dto);
}