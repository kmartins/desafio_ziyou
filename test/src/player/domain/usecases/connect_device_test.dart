import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class StreamingDeviceServiceMock extends Mock
    implements StreamingDeviceService {}

void main() {
  group('ConnectDevice', () {
    late final ConnectDevice connectDevice;
    late final StreamingDeviceServiceMock streamingDeviceService;

    setUpAll(() {
      streamingDeviceService = StreamingDeviceServiceMock();
      connectDevice = ConnectDevice(streamingDeviceService);
    });

    test('O player deve conectar ao dispositivo informado', () {
      when(() => streamingDeviceService.startDevice('1234'))
          .thenAnswer((_) async {});

      expect(() => connectDevice('1234'), returnsNormally);
      verify(() => streamingDeviceService.startDevice('1234'));
    });
  });
}
