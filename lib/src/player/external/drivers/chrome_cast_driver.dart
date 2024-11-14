import 'dart:convert';

import 'package:desafio_ziyou/src/player/infra/drivers/streaming_device_driver.dart';
import 'package:flutter/services.dart';

final class ChromeCastDriver implements StreamingDeviceDriver {
  const ChromeCastDriver({
    required MethodChannel playerChromeCastChannel,
    required EventChannel sessionChromeCastEventChannel,
    required EventChannel discoveryChromeCastEventChannel,
  })  : _playerChromeCastChannel = playerChromeCastChannel,
        _sessionChromeCastEventChannel = sessionChromeCastEventChannel,
        _discoveryChromeCastEventChannel = discoveryChromeCastEventChannel;

  final MethodChannel _playerChromeCastChannel;
  final EventChannel _sessionChromeCastEventChannel;
  final EventChannel _discoveryChromeCastEventChannel;

  @override
  Future<void> disconnectDevice() => _playerChromeCastChannel
      .invokeMethod(StreamingDeviceMethods.disconnectDevice.value);

  @override
  Stream<List<dynamic>> discoverDevices() =>
      _discoveryChromeCastEventChannel.receiveBroadcastStream().map(
            (value) => jsonDecode(value as String) as List<dynamic>,
          );

  @override
  Stream<String> listenDeviceSession() =>
      _sessionChromeCastEventChannel.receiveBroadcastStream().map(
            (event) => event.toString(),
          );

  @override
  Future<void> play() =>
      _playerChromeCastChannel.invokeMethod(StreamingDeviceMethods.play.value);

  @override
  Future<void> pause() =>
      _playerChromeCastChannel.invokeMethod(StreamingDeviceMethods.pause.value);

  @override
  Future<void> seek(int positionDuration) =>
      _playerChromeCastChannel.invokeMethod(
        StreamingDeviceMethods.seek.value,
        positionDuration,
      );

  @override
  Future<void> setMedia(Map<String, dynamic> data) => _playerChromeCastChannel
      .invokeMethod(StreamingDeviceMethods.setMedia.value, data);

  @override
  Future<void> startDevice(String id) => _playerChromeCastChannel.invokeMethod(
      StreamingDeviceMethods.startDevice.value, id);
}
