import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/dto/publicacion_request.dart';
import 'package:nexoband_mobile/core/model/publicacion_response.dart';
import 'package:nexoband_mobile/core/service/publicacion_service.dart';

part 'publicacion_event.dart';
part 'publicacion_state.dart';

class PublicacionBloc extends Bloc<PublicacionEvent, PublicacionState> {
  PublicacionBloc(PublicacionService publicacionService)
    : super(PublicacionInitial()) {
    on<CargarPublicacionesUsuario>((event, emit) async {
      emit(PublicacionesCargando());
      try {
        final publicaciones = await publicacionService
            .listarPublicacionesUsuario();
        emit(PublicacionesCargadas(publicaciones));
      } catch (e) {
        emit(PublicacionesCargaError(e.toString()));
      }
    });

    on<CrearPublicacion>((event, emit) async {
      emit(PublicacionesCreando());
      try {
        final publicacionCreada = await publicacionService.crearPublicacion(
          event.request,multimedia:event.multimedia
        );
        emit(PublicacionCreada(publicacionCreada));
      } catch (e) {
        emit(PublicacionCreacionError(e.toString()));
      }
    });

    on<EliminarPublicacion>((event, emit) async {
      try {
        await publicacionService.eliminarPublicacion(event.publicacionId);
        emit(PublicacionEliminada(event.publicacionId));
      } catch (e) {
        emit(PublicacionEliminacionError(e.toString()));
      }
    });

    on<CargarFeed>((event, emit) async {
      emit(FeedCargando());
      try {
        final publicaciones = await publicacionService.listarFeed();
        if (publicaciones.isEmpty) {
          emit(FeedVacio());
        } else {
          emit(FeedCargado(publicaciones));
        }
      } catch (e) {
        emit(FeedCargaError(e.toString()));
      }
    });
  }
}
