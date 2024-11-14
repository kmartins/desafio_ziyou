import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class StreamingDeviceServiceMock extends Mock
    implements StreamingDeviceService {}

void main() {
  group('SeekTo', () {
    late final SeekTo seekTo;
    late final StreamingDeviceServiceMock streamingDeviceService;

    setUpAll(() {
      streamingDeviceService = StreamingDeviceServiceMock();
      seekTo = SeekTo(streamingDeviceService);
    });

    test('O player deve pular para a posição informada', () {
      when(() => streamingDeviceService.seek(const Duration(seconds: 100)))
          .thenAnswer((_) async {});
      expect(() => seekTo(const Duration(seconds: 100)), returnsNormally);

      verify(() => streamingDeviceService.seek(const Duration(seconds: 100)));
    });
  });
}
