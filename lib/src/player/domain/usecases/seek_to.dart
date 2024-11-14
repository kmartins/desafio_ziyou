import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';

class SeekTo {
  const SeekTo(this._chromeCastDevice);

  final StreamingDeviceService _chromeCastDevice;

  Future<void> call(Duration position) => _chromeCastDevice.seek(position);
}
