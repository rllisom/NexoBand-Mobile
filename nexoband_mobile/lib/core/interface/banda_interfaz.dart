
import 'package:nexoband_mobile/core/model/banda_response.dart';

abstract class BandaInterfaz {
  Future<BandaResponse> getBandaDetail(int bandaId);
}