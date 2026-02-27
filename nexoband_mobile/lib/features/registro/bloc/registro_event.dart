import 'package:nexoband_mobile/core/dto/register_request.dart';

sealed class RegistroEvent {}

class RealizarRegistroEvent extends RegistroEvent {
  final RegisterRequest request;

  RealizarRegistroEvent({
    required this.request,
  });
}