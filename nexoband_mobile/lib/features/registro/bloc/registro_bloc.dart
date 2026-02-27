import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexoband_mobile/core/service/register_service.dart';
import 'package:nexoband_mobile/features/registro/bloc/registro_event.dart';
import 'package:nexoband_mobile/features/registro/bloc/registro_state.dart';



class RegistroBloc extends Bloc<RegistroEvent, RegistroState> {
  final RegisterService _registerService;

  RegistroBloc(this._registerService) : super(RegistroInitial()) {
    on<RealizarRegistroEvent>((event, emit) async {   
      emit(RegistroLoading());
      try {
        await _registerService.register(event.request);
        emit(RegistroSuccess());
      } catch (e) {
        String mensaje = e.toString().replaceFirst('Exception: ', '');
        emit(RegistroFailure( mensaje));
      }
    });
  }
}
