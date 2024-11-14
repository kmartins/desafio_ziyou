import 'dart:convert';

import 'package:desafio_ziyou/src/player/domain/entities/media_entity.dart';
import 'package:desafio_ziyou/src/player/external/drivers/chrome_cast_driver.dart';
import 'package:desafio_ziyou/src/player/infra/drivers/streaming_device_driver.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StreamingDeviceServiceImpl', () {
    const playerChromeCastChannel =
        MethodChannel('br.com.ziyou/player_chrome_cast');
    const discoveryChromeCastEventChannel =
        EventChannel('br.com.ziyou/discovery_chrome_cast');
    const sessionChromeCastEventChannel =
        EventChannel('br.com.ziyou/chrome_cast_session');
    late final ChromeCastDriver chromeCastDriver;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      chromeCastDriver = const ChromeCastDriver(
        playerChromeCastChannel: playerChromeCastChannel,
        sessionChromeCastEventChannel: sessionChromeCastEventChannel,
        discoveryChromeCastEventChannel: discoveryChromeCastEventChannel,
      );
    });

    test('O evento de play deve ser recebido na plataforma host', () {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(playerChromeCastChannel,
              (MethodCall methodCall) async {
        if (methodCall.method == StreamingDeviceMethods.play.value) {
          return null;
        }
        return Exception('Unexpected method call ${methodCall.method}');
      });

      expect(chromeCastDriver.play, returnsNormally);
    });

    test('O evento de pause deve ser recebido na plataforma host', () {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(playerChromeCastChannel,
              (MethodCall methodCall) async {
        if (methodCall.method == StreamingDeviceMethods.pause.value) {
          return null;
        }
        return Exception('Unexpected method call ${methodCall.method}');
      });

      expect(chromeCastDriver.pause, returnsNormally);
    });

    test(
        'O evento de desconectar o device deve ser recebido na plataforma host',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(playerChromeCastChannel,
              (MethodCall methodCall) async {
        if (methodCall.method ==
            StreamingDeviceMethods.disconnectDevice.value) {
          return null;
        }
        return Exception('Unexpected method call ${methodCall.method}');
      });

      expect(chromeCastDriver.disconnectDevice, returnsNormally);
    });

    test(
        'O evento de pular para a posição no player deve ser recebido na plataforma host',
        () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(playerChromeCastChannel,
              (MethodCall methodCall) async {
        if (methodCall.method == StreamingDeviceMethods.seek.value &&
            (methodCall.arguments as int) == 100) {
          return null;
        }
        return Exception('Unexpected method call ${methodCall.method}');
      });

      expect(() => chromeCastDriver.seek(100), returnsNormally);
    });

    test('O evento de setar mídia recebido na plataforma host', () {
      final media = MediaEntity(
        url: 'https://ziyou.com',
        contentType: 'video/mp4',
        isPlaying: true,
        playPosition: const Duration(seconds: 100),
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(playerChromeCastChannel,
              (MethodCall methodCall) async {
        if (methodCall.method == StreamingDeviceMethods.setMedia.value &&
            methodCall.arguments is Map<Object?, Object?>) {
          return null;
        }
        return Exception('Unexpected method call ${methodCall.method}');
      });

      expect(() => chromeCastDriver.setMedia(media.toJson()), returnsNormally);
    });

    test('Deve receber devices encontrados da plataforma host', () {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
        discoveryChromeCastEventChannel,
        MockStreamHandler.inline(
          onListen: (_, events) {
            events.success(
              json.encode(
                [
                  {'id': '1234', 'name': 'device1'}
                ],
              ),
            );
          },
        ),
      );

      final devices = chromeCastDriver.discoverDevices();
      expect(
        devices,
        emits(
          [
            {'id': '1234', 'name': 'device1'}
          ],
        ),
      );
    });

    test('Deve receber o estado da sessão da plataforma host', () {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
        sessionChromeCastEventChannel,
        MockStreamHandler.inline(
          onListen: (_, events) => events.success('connecting'),
        ),
      );

      final sessionEvents = chromeCastDriver.listenDeviceSession();
      expect(sessionEvents, emits('connecting'));
    });
  });
}
