import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  final PerfilService perfilService;

  PerfilBloc(this.perfilService) : super(PerfilInitial()) {
    

    on<CargarPerfil>((event, emit) async {
      emit(PerfilCargando());
      try {
        final usuario = await perfilService.cargarPerfil();
        emit(PerfilCargado(usuario));
      } catch (e) {
        emit(PerfilError(e.toString()));
      }
    });


    on<RefrescarPerfil>((event, emit) async {
      emit(PerfilCargando());
      try {
        final usuario = await perfilService.cargarPerfil();
        emit(PerfilCargado(usuario));
      } catch (e) {
        emit(PerfilError(e.toString()));
      }
    });


    on<EditarImagenPerfil>((event, emit) async {
      emit(ImagenPerfilCargando());
      try {
        // 1. Sube imagen
        final nuevaUrl = await perfilService.editarImagenPerfil(
          event.usuarioId,
          event.imagePath,
        );
        
        if (nuevaUrl != null) {
          emit(ImagenPerfilActualizada(nuevaUrl)); 
        }

        // 2. Recarga perfil completo (garantiza consistencia)
        final usuarioActualizado = await perfilService.cargarPerfil();
        emit(PerfilCargado(usuarioActualizado)); // 👈 Estado final
        
      } catch (e) {
        emit(ImagenPerfilError(e.toString()));
      }
    });

  }
}
