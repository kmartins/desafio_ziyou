import 'package:desafio_ziyou/src/player/domain/entities/media_entity.dart';
import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class StreamingDeviceServiceMock extends Mock
    implements StreamingDeviceService {}

void main() {
  group('SendMediaToDevice', () {
    late final SendMediaToDevice sendMediaToDevice;
    late final StreamingDeviceServiceMock streamingDeviceService;

    setUpAll(() {
      streamingDeviceService = StreamingDeviceServiceMock();
      sendMediaToDevice = SendMediaToDevice(streamingDeviceService);
    });

    test('A mídia deve ser enviada para o dispositivo', () {
      final media = MediaEntity(
        url: 'https://ziyou.com',
        contentType: 'video/mp4',
        isPlaying: true,
        playPosition: const Duration(seconds: 100),
      );
      when(() => streamingDeviceService.setMedia(media))
          .thenAnswer((_) async {});

      expect(() => sendMediaToDevice(media), returnsNormally);
      verify(() => streamingDeviceService.setMedia(media));
    });
  });
}
