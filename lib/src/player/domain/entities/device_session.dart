enum DeviceSession {
  disconnected('disconnected'),
  disconnecting('disconnecting'),
  connecting('connecting'),
  connected('connected');

  const DeviceSession(this.value);

  final String value;
}
