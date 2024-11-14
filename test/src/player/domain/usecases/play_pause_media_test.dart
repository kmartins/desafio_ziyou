import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class StreamingDeviceServiceMock extends Mock
    implements StreamingDeviceService {}

void main() {
  group('PlayPauseMedia', () {
    late final PlayPauseMedia playPauseMedia;
    late final StreamingDeviceServiceMock streamingDeviceService;

    setUpAll(() {
      streamingDeviceService = StreamingDeviceServiceMock();
      playPauseMedia = PlayPauseMedia(streamingDeviceService);
    });

    test('Quando o player estiver tocando então deve pausar', () {
      when(streamingDeviceService.pause).thenAnswer((_) async {});

      expect(() => playPauseMedia(true), returnsNormally);
      verify(streamingDeviceService.pause);
      verifyNever(streamingDeviceService.play);
    });

    test('Quando o player estiver pausado então deve tocar', () async {
      when(streamingDeviceService.pause).thenAnswer((_) async {});

      expect(() => playPauseMedia(true), returnsNormally);
      verify(streamingDeviceService.pause);
      verifyNever(streamingDeviceService.play);
    });
  });
}
