import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';

part 'publicacion_event.dart';
part 'publicacion_state.dart';

class PublicacionBloc extends Bloc<PublicacionEvent, PublicacionState> {


  PublicacionBloc(PublicacionService publicacionService) : super(PublicacionInitial()) {
    on<DarMeGustaPublicacion>((event, emit) {
      try {
        emit(DarMeGustaState(event.publicacionId, event.usuarioId));
      } catch (e) {
        emit(MeGustaErrorState('Error al dar me gusta: ${e.toString()}'));
      }
    });

    on<QuitarMeGustaPublicacion>((event, emit) {
      try {
        emit(QuitarMeGustaState(event.publicacionId, event.usuarioId));
      } catch (e) {
        emit(MeGustaErrorState('Error al quitar me gusta: ${e.toString()}'));
      }
    });
  }
}
