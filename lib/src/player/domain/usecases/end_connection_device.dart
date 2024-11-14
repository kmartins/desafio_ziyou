import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';

class EndConnectionDevice {
  const EndConnectionDevice(this._chromeCastDevice);

  final StreamingDeviceService _chromeCastDevice;

  Future<void> call() => _chromeCastDevice.disconnectDevice();
}
