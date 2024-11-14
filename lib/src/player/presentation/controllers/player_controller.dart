import 'dart:async';

import 'package:desafio_ziyou/src/core/state/async_state.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_entity.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_session.dart';
import 'package:desafio_ziyou/src/player/domain/entities/media_entity.dart';
import 'package:desafio_ziyou/src/player/domain/usecases/usecases.dart';
import 'package:desafio_ziyou/src/player/presentation/controllers/player_state.dart';
import 'package:flutter/foundation.dart';

class PlayerController extends ValueNotifier<PlayerState> {
  PlayerController({
    required ConnectDevice connectDevice,
    required DiscoveryDevice discoveryDevice,
    required EndConnectionDevice endConnectionDevice,
    required PlayPauseMedia playPauseMedia,
    required SeekTo seekTo,
    required SendMediaToDevice sendMediaToDevice,
    required ListenSession listenSession,
  })  : _connectDevice = connectDevice,
        _discoveryDevice = discoveryDevice,
        _endConnectionDevice = endConnectionDevice,
        _playPauseMedia = playPauseMedia,
        _seekTo = seekTo,
        _sendMediaToDevice = sendMediaToDevice,
        _listenSession = listenSession,
        super(const PlayerState());

  final ConnectDevice _connectDevice;

  final DiscoveryDevice _discoveryDevice;

  final EndConnectionDevice _endConnectionDevice;

  final PlayPauseMedia _playPauseMedia;

  final SeekTo _seekTo;

  final SendMediaToDevice _sendMediaToDevice;

  final ListenSession _listenSession;

  StreamSubscription<List<Device>>? _discoveryDeviceSubscription;

  StreamSubscription<DeviceSession>? _deviceSessionSubscription;

  void handleStartConnectionWithDevice(Device device) =>
      _connectDevice(device.id);

  void handleSetMedia(MediaEntity mediaEntity) =>
      _sendMediaToDevice(mediaEntity);

  void handlePlayPause(bool isPlaying) => _playPauseMedia.call(isPlaying);

  void handleSeek(Duration position) => _seekTo(position);

  void handleFinishConnectionWithDevice() => _endConnectionDevice();

  void handleDiscoveryDevices() {
    value = value.copyWith(discoveryDeviceState: const AsyncLoading());
    _discoveryDeviceSubscription?.cancel();
    _discoveryDeviceSubscription = _discoveryDevice().listen(
      (devices) => value = value.copyWith(
        discoveryDeviceState: AsyncData(devices),
      ),
    );
  }

  void handleDeviceSession() {
    value = value.copyWith(deviceSessionState: const AsyncLoading());
    _deviceSessionSubscription?.cancel();
    _deviceSessionSubscription = _listenSession().listen(
      (state) => value = value.copyWith(
        deviceSessionState: AsyncData(state),
      ),
    );
  }

  @override
  void dispose() {
    _endConnectionDevice();
    _discoveryDeviceSubscription?.cancel();
    _deviceSessionSubscription?.cancel();
    super.dispose();
  }
}
