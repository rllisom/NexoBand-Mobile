import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/model/user_response.dart';
import 'package:nexoband_mobile/core/service/perfil_service.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  final PerfilService perfilService;
  PerfilBloc(this.perfilService) : super(PerfilInitial()) {
    on<CargarPerfil>((event, emit) {
      emit(PerfilCargando());
      perfilService.cargarPerfil().then((usuario) {
        emit(PerfilCargado(usuario));
      }).catchError((error) {
        emit(PerfilError(error.toString()));
      });
    });
  }
}
