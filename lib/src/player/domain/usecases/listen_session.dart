import 'package:desafio_ziyou/src/player/domain/entities/device_session.dart';
import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';

class ListenSession {
  const ListenSession(this._chromeCastDevice);

  final StreamingDeviceService _chromeCastDevice;

  Stream<DeviceSession> call() => _chromeCastDevice.listenDeviceSession();
}
