import 'package:desafio_ziyou/src/player/domain/entities/device_session.dart';
import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class StreamingDeviceServiceMock extends Mock
    implements StreamingDeviceService {}

void main() {
  group('ListenSession', () {
    late final ListenSession listenSession;
    late final StreamingDeviceServiceMock streamingDeviceService;

    setUpAll(() {
      streamingDeviceService = StreamingDeviceServiceMock();
      listenSession = ListenSession(streamingDeviceService);
    });

    test('Os eventos da sessão devem ser recebidos', () {
      when(streamingDeviceService.listenDeviceSession).thenAnswer(
        (_) => Stream.fromIterable(
          [
            DeviceSession.connecting,
            DeviceSession.connected,
          ],
        ),
      );
      final sessionEvents = listenSession();
      expect(
        sessionEvents,
        emitsInOrder(
          [DeviceSession.connecting, DeviceSession.connected],
        ),
      );
      verify(streamingDeviceService.listenDeviceSession);
    });
  });
}
