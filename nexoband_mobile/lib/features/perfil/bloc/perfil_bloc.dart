import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  PerfilBloc() : super(PerfilInitial()) {
    on<PerfilEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
