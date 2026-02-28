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