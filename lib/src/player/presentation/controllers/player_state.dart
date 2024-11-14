import 'package:desafio_ziyou/src/core/state/async_state.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_entity.dart';
import 'package:desafio_ziyou/src/player/domain/entities/device_session.dart';

final class PlayerState {
  const PlayerState({
    this.discoveryDeviceState = const AsyncLoading(),
    this.deviceSessionState = const AsyncData(DeviceSession.disconnected),
  });

  final AsyncState<List<Device>> discoveryDeviceState;
  final AsyncState<DeviceSession> deviceSessionState;

  @override
  bool operator ==(covariant PlayerState other) {
    if (identical(this, other)) return true;

    return other.discoveryDeviceState == discoveryDeviceState &&
        other.deviceSessionState == deviceSessionState;
  }

  @override
  int get hashCode =>
      discoveryDeviceState.hashCode ^ deviceSessionState.hashCode;

  @override
  String toString() =>
      'PlayState(discoveryDeviceState: $discoveryDeviceState, deviceSessionState: $deviceSessionState)';

  PlayerState copyWith({
    AsyncState<List<Device>>? discoveryDeviceState,
    AsyncState<DeviceSession>? deviceSessionState,
  }) {
    return PlayerState(
      discoveryDeviceState: discoveryDeviceState ?? this.discoveryDeviceState,
      deviceSessionState: deviceSessionState ?? this.deviceSessionState,
    );
  }
}
