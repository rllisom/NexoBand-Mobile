import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ajustes_event.dart';
part 'ajustes_state.dart';

class AjustesBloc extends Bloc<AjustesEvent, AjustesState> {
  AjustesBloc() : super(AjustesInitial()) {
    on<AjustesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
