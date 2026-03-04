part of 'banda_bloc.dart';

@immutable
sealed class BandaEvent {}


class LoadBandaDetail extends BandaEvent {
  final int bandaId;
  LoadBandaDetail(this.bandaId);
}


class CrearBanda extends BandaEvent {
  final BandaRequest bandaRequest;
  CrearBanda(this.bandaRequest);
}

class EliminarBanda extends BandaEvent {
  final int bandaId;
  EliminarBanda(this.bandaId);
}

class EditarFotoPerfilBanda extends BandaEvent {  // ✅ NUEVO
  final int bandaId;
  final String imagePath;
  EditarFotoPerfilBanda({required this.bandaId, required this.imagePath});
}


class AgregarMiembroBanda extends BandaEvent {
  final int bandaId;
  final int userId;
  AgregarMiembroBanda(this.bandaId, this.userId);
}

class EliminarMiembroBanda extends BandaEvent {
  final int bandaId;
  final int userId;
  EliminarMiembroBanda(this.bandaId, this.userId);
}