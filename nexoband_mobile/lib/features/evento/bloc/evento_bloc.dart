import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/dto/evento_request.dart';
import 'package:nexoband_mobile/core/model/evento_response.dart';
import 'package:nexoband_mobile/core/service/evento_service.dart';

part 'evento_event.dart';
part 'evento_state.dart';

class EventoBloc extends Bloc<EventoEvent, EventoState> {
  final EventoService eventoService;
  EventoBloc(this.eventoService) : super(EventoInitial()){
    on<EventoEvent>((event, emit) async{
      if(event is CrearEvento) {
        emit(EventoCreando());
        try {
          final evento = await eventoService.crearEvento(event.dto);
          emit(EventoCreado(evento));
        } catch (e) {
          emit(EventoCreadoError(e.toString()));
        }
      }
      else if(event is CargarEventos) {
        emit(EventosCargando());
        try {
          final eventos = await eventoService.cargarEventos(soloProximos: event.soloProximos);
          emit(EventosCargados(eventos));
        } catch (e) {
          emit(EventosCargaError(e.toString()));
        }
      }
    });
  }
}
