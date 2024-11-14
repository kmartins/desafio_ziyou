import 'package:desafio_ziyou/src/player/domain/entities/media_entity.dart';
import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';

class SendMediaToDevice {
  const SendMediaToDevice(this._chromeCastDevice);

  final StreamingDeviceService _chromeCastDevice;

  Future<void> call(MediaEntity mediaEntity) =>
      _chromeCastDevice.setMedia(mediaEntity);
}
