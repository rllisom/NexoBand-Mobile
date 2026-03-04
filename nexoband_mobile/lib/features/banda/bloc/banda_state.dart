part of 'banda_bloc.dart';

@immutable
sealed class BandaState {}

final class BandaInitial extends BandaState {}

// ── Carga detalle ────────────────────────────────────────────────────
class BandaDetailLoading extends BandaState {}

class BandaDetailLoaded extends BandaState {
  final BandaResponse banda;
  BandaDetailLoaded(this.banda);
}

class BandaDetailError extends BandaState {
  final String mensaje;
  BandaDetailError(this.mensaje);
}

// ── Crear banda ──────────────────────────────────────────────────────
class CreandoBanda extends BandaState {}

class BandaCreada extends BandaState {}

class BandaCreacionError extends BandaState {
  final String mensaje;
  BandaCreacionError(this.mensaje);
}

//---Eliminar banda --------------------------------
class EliminandoBanda extends BandaState {}
class BandaEliminada extends BandaState {}
class BandaEliminacionError extends BandaState {
  final String mensaje;
  BandaEliminacionError(this.mensaje);
}


// ── Editar banda ─────────────────────────────────────────────────────
class EditandoBanda extends BandaState {}

class BandaEditada extends BandaState {}

class BandaEdicionError extends BandaState {
  final String mensaje;
  BandaEdicionError(this.mensaje);
}

// ── Imagen de perfil ─────────────────────────────────────────────────
class BandaFotoSubiendo extends BandaState {} 

// ── Agregar miembro ──────────────────────────────────────────────────
class AgregarMiembroLoading extends BandaState {}

class MiembroAgregado extends BandaState {}

class AgregarMiembroError extends BandaState {
  final String mensaje;
  AgregarMiembroError(this.mensaje);
}

//------Eliminar miembro─────────────────────────────────────────────────────
class EliminarMiembroLoading extends BandaState {}

class MiembroEliminado extends BandaState {}

class EliminarMiembroError extends BandaState {
  final String mensaje;
  EliminarMiembroError(this.mensaje);
}