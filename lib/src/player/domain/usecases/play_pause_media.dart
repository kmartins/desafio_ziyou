import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';

class PlayPauseMedia {
  const PlayPauseMedia(this._chromeCastDevice);

  final StreamingDeviceService _chromeCastDevice;

  Future<void> call(bool isPlaying) =>
      isPlaying ? _chromeCastDevice.pause() : _chromeCastDevice.play();
}
