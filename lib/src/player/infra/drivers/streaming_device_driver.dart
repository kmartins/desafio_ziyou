enum StreamingDeviceMethods {
  startDevice('start_device'),
  setMedia('set_media'),
  seek('seek'),
  play('play'),
  pause('pause'),
  disconnectDevice('disconnect_device');

  const StreamingDeviceMethods(this.value);

  final String value;
}

abstract interface class StreamingDeviceDriver {
  Stream<List<dynamic>> discoverDevices();
  Future<void> startDevice(String id);
  Future<void> setMedia(Map<String, dynamic> data);
  Future<void> seek(int positionDuration);
  Future<void> play();
  Future<void> pause();
  Future<void> disconnectDevice();
  Stream<String> listenDeviceSession();
}
