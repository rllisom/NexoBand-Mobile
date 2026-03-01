import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexoband_mobile/core/dto/banda_request.dart';
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
        emit(BandaDetailError('Error: $e'));
      }
    });

    on<EditarFotoPerfilBanda>((event, emit) async {  // ✅ NUEVO

      final estadoActual = state;
      emit(BandaFotoSubiendo());
      try {
        await bandaService.editarImagenPerfil(event.bandaId, event.imagePath);
        // Recarga el detalle con la nueva foto
        final banda = await bandaService.getBandaDetail(event.bandaId);
        emit(BandaDetailLoaded(banda));
      } catch (e) {
        // Restaura el estado anterior si falla
        if (estadoActual is BandaDetailLoaded) emit(estadoActual);
        emit(BandaDetailError('Error al subir la imagen: $e'));
      }
    });

    on<AgregarMiembroBanda>((event, emit) async {
      emit(AgregarMiembroLoading());
      try {
        await bandaService.agregarMiembro(event.bandaId, event.userId);
        emit(MiembroAgregado());
      } catch (e) {
        emit(AgregarMiembroError('Error al agregar miembro: $e'));
      }
    });
  }
}
