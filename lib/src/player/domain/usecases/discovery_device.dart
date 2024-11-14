import 'package:desafio_ziyou/src/player/domain/entities/device_entity.dart';
import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';

class DiscoveryDevice {
  const DiscoveryDevice(this._chromeCastDevice);

  final StreamingDeviceService _chromeCastDevice;

  Stream<List<Device>> call() => _chromeCastDevice.discoverDevices();
}
