import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/model/banda_response.dart';
import 'package:nexoband_mobile/core/service/banda_service.dart';


part 'banda_event.dart';
part 'banda_state.dart';

class BandaBloc extends Bloc<BandaEvent, BandaState> {
  final BandaService bandaService;

  BandaBloc({required this.bandaService}) : super(BandaInitial()) {
    on<LoadBandaDetail>((event, emit) async {
      emit(BandaDetailLoading());
      try {
        final banda = await bandaService.getBandaDetail(event.bandaId);
        emit(BandaDetailLoaded(banda));
      } catch (e) {
        emit(BandaDetailError('Error al cargar los detalles de la banda'));
      }
    });
  }
}
