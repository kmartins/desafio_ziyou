import 'package:desafio_ziyou/src/player/domain/entities/device_entity.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_session.dart';
import 'package:desafio_ziyou/src/player/domain/entities/media_entity.dart';

abstract interface class StreamingDeviceService {
  Stream<List<Device>> discoverDevices();
  Future<void> startDevice(String id);
  Future<void> setMedia(MediaEntity mediaEntity);
  Future<void> seek(Duration positionDuration);
  Future<void> play();
  Future<void> pause();
  Future<void> disconnectDevice();
  Stream<DeviceSession> listenDeviceSession();
}
