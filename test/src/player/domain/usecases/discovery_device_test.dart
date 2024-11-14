import 'package:desafio_ziyou/src/player/domain/entities/device_entity.dart';
import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class StreamingDeviceServiceMock extends Mock
    implements StreamingDeviceService {}

void main() {
  group('DiscoveryDevice', () {
    late final DiscoveryDevice discoveryDevice;
    late final StreamingDeviceServiceMock streamingDeviceService;

    setUpAll(() {
      streamingDeviceService = StreamingDeviceServiceMock();
      discoveryDevice = DiscoveryDevice(streamingDeviceService);
    });

    test('O devices encontrados devem ser recebidos', () {
      when(streamingDeviceService.discoverDevices).thenAnswer(
        (_) => Stream.fromIterable(
          [
            [Device(id: '1234', name: 'device1')],
            [
              Device(id: '1234', name: 'device1'),
              Device(id: '5678', name: 'device2')
            ],
          ],
        ),
      );
      final devices = discoveryDevice();
      expect(
        devices,
        emitsInOrder(
          [
            [Device(id: '1234', name: 'device1')],
            [
              Device(id: '1234', name: 'device1'),
              Device(id: '5678', name: 'device2')
            ]
          ],
        ),
      );
      verify(streamingDeviceService.discoverDevices);
    });
  });
}
