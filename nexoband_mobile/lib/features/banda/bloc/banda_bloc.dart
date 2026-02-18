import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'banda_event.dart';
part 'banda_state.dart';

class BandaBloc extends Bloc<BandaEvent, BandaState> {
  BandaBloc() : super(BandaInitial()) {
    on<BandaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
