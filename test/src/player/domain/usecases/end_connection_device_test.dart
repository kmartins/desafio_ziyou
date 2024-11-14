import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class StreamingDeviceServiceMock extends Mock
    implements StreamingDeviceService {}

void main() {
  group('EndConnectionDevice', () {
    late final EndConnectionDevice endConnectDevice;
    late final StreamingDeviceServiceMock streamingDeviceService;

    setUpAll(() {
      streamingDeviceService = StreamingDeviceServiceMock();
      endConnectDevice = EndConnectionDevice(streamingDeviceService);
    });

    test('O player deve encerrar a conexão com o device', () {
      when(streamingDeviceService.disconnectDevice).thenAnswer((_) async {});

      expect(() => endConnectDevice(), returnsNormally);
      verify(streamingDeviceService.disconnectDevice);
    });
  });
}
