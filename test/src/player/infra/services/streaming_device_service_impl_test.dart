import 'package:desafio_ziyou/src/player/domain/entities/device_entity.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_session.dart';
import 'package:desafio_ziyou/src/player/domain/entities/media_entity.dart';
import 'package:desafio_ziyou/src/player/domain/services/streaming_device_service.dart';
import 'package:desafio_ziyou/src/player/infra/drivers/streaming_device_driver.dart';
import 'package:desafio_ziyou/src/player/infra/services/streaming_device_service_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class StreamingDeviceDriverMock extends Mock implements StreamingDeviceDriver {}

void main() {
  group('StreamingDeviceServiceImpl', () {
    late final StreamingDeviceService streamingDeviceService;
    late final StreamingDeviceDriverMock streamingDeviceDriver;

    setUpAll(() {
      streamingDeviceDriver = StreamingDeviceDriverMock();
      streamingDeviceService = StreamingDeviceServiceImpl(
        chromeCastDriver: streamingDeviceDriver,
      );
    });

    test('O devices encontrados devem ser recebidos', () {
      when(streamingDeviceDriver.discoverDevices).thenAnswer(
        (_) => Stream.fromIterable(
          [
            [
              {'id': '1234', 'name': 'device1'}
            ],
            [
              {'id': '1234', 'name': 'device1'},
              {'id': '5678', 'name': 'device2'}
            ],
          ],
        ),
      );
      final devices = streamingDeviceService.discoverDevices();
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

    test('Os eventos da sessão devem ser recebidos', () async {
      when(streamingDeviceDriver.listenDeviceSession).thenAnswer(
        (_) => Stream.fromIterable(
          [
            'connecting',
            'connected',
          ],
        ),
      );
      final sessionEvents = streamingDeviceService.listenDeviceSession();
      expect(
        sessionEvents,
        emitsInOrder(
          [DeviceSession.connecting, DeviceSession.connected],
        ),
      );
      verify(streamingDeviceService.listenDeviceSession);
    });

    test('O player deve conectar ao dispositivo informado', () {
      when(() => streamingDeviceDriver.startDevice('1234'))
          .thenAnswer((_) async {});

      expect(() => streamingDeviceService.startDevice('1234'), returnsNormally);
      verify(() => streamingDeviceDriver.startDevice('1234'));
    });

    test('Uma media deve ser enviada para o dispositivo', () {
      final media = MediaEntity(
        url: 'https://ziyou.com',
        contentType: 'video/mp4',
        isPlaying: true,
        playPosition: const Duration(seconds: 100),
      );
      when(() => streamingDeviceDriver.setMedia(media.toJson()))
          .thenAnswer((_) async {});

      expect(() => streamingDeviceService.setMedia(media), returnsNormally);
      verify(() => streamingDeviceDriver.setMedia(media.toJson()));
    });

    test('O player deve pular para a posição informada', () {
      when(() => streamingDeviceDriver.seek(100)).thenAnswer((_) async {});

      expect(() => streamingDeviceService.seek(const Duration(seconds: 100)),
          returnsNormally);
      verify(() => streamingDeviceDriver.seek(100));
    });

    test('O player deve tocar', () {
      when(streamingDeviceDriver.play).thenAnswer((_) async {});

      expect(streamingDeviceService.play, returnsNormally);
      verify(streamingDeviceDriver.play);
    });

    test('O player deve pausar', () {
      when(streamingDeviceDriver.pause).thenAnswer((_) async {});

      expect(streamingDeviceService.pause, returnsNormally);
      verify(streamingDeviceDriver.pause);
    });

    test('A conexão com o dispositivo deve ser encerrada', () {
      when(streamingDeviceDriver.disconnectDevice).thenAnswer((_) async {});

      expect(streamingDeviceService.disconnectDevice, returnsNormally);
      verify(streamingDeviceDriver.disconnectDevice);
    });
  });
}
