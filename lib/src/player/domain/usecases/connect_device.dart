import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';

class ConnectDevice {
  const ConnectDevice(this._chromeCastDevice);

  final StreamingDeviceService _chromeCastDevice;

  Future<void> call(String deviceId) => _chromeCastDevice.startDevice(deviceId);
}
