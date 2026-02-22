import 'package:nexoband_mobile/core/model/chat_response.dart';

abstract class MensajeInterface {
  Future<Mensaje> enviarMensaje(int chatId, int userId, String texto);
}