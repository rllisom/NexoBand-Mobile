import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/dto/publicacion_request.dart';
import 'package:nexoband_mobile/core/model/publicacion_list_response.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {

  final PublicacionService publicacionService;

  HomePageBloc(this.publicacionService) : super(HomePageInitial()) {
    
    on<CargarPublicacionesUsuario>((event, emit) async {
      emit(PublicacionesCargando());
      try {
        final publicaciones = await publicacionService.listarPublicacionesUsuario();
        emit(PublicacionesCargadas(publicaciones));
      } catch (e) {
        emit(PublicacionesCargaError(e.toString()));
      }
    });

    on<CrearPublicacion>((event, emit) async {
      emit(PublicacionesCreando());
      try {
        final publicacionCreada = await publicacionService.crearPublicacion(event.request);
        emit(PublicacionCreada(publicacionCreada));
      } catch (e) {
        emit(PublicacionCreacionError(e.toString()));
      }
    });

    on<EliminarPublicacion>((event, emit) async {
      emit(PublicacionEliminada(  event.publicacionId));
      try {
        await publicacionService.eliminarPublicacion(event.publicacionId);
        emit(PublicacionEliminada(event.publicacionId));
      } catch (e) {
        emit(PublicacionEliminacionError(e.toString()));
      }
    });
  }
}
