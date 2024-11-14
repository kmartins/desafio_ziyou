import 'package:desafio_ziyou/src/player/domain/entities/device_entity.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_session.dart';
import 'package:desafio_ziyou/src/player/domain/entities/media_entity.dart';
import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/infra/drivers/streaming_device_driver.dart';

final class StreamingDeviceServiceImpl implements StreamingDeviceService {
  const StreamingDeviceServiceImpl(
      {required StreamingDeviceDriver chromeCastDriver})
      : _chromeCastDriver = chromeCastDriver;

  final StreamingDeviceDriver _chromeCastDriver;

  @override
  Stream<List<Device>> discoverDevices() =>
      _chromeCastDriver.discoverDevices().map(
            (value) => value.map((e) => Device.fromMap(e)).toList(),
          );

  @override
  Future<void> startDevice(String id) => _chromeCastDriver.startDevice(id);

  @override
  Future<void> setMedia(MediaEntity mediaData) =>
      _chromeCastDriver.setMedia(mediaData.toJson());

  @override
  Future<void> seek(Duration positionDuration) =>
      _chromeCastDriver.seek(positionDuration.inSeconds);

  @override
  Future<void> play() => _chromeCastDriver.play();

  @override
  Future<void> pause() => _chromeCastDriver.pause();

  @override
  Future<void> disconnectDevice() => _chromeCastDriver.disconnectDevice();

  @override
  Stream<DeviceSession> listenDeviceSession() {
    return _chromeCastDriver.listenDeviceSession().map(
          (data) => DeviceSession.values
              .firstWhere((element) => element.value == data),
        );
  }
}
