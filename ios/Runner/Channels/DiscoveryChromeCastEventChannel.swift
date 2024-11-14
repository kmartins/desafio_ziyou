import GoogleCast

class DiscoveryChromeCastEventChannel : NSObject, GCKDiscoveryManagerListener, FlutterStreamHandler {
    private var eventSink : FlutterEventSink?
    private var foundDevices : [UInt : GCKDevice] = [:]
    private var discoveryManager: GCKDiscoveryManager{
        GCKCastContext.sharedInstance().discoveryManager
    }
    
    // MARK: - FlutterStreamHandler
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        discoveryManager.add(self)
        discoveryManager.startDiscovery()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        discoveryManager.remove(self)
        discoveryManager.stopDiscovery()
        eventSink = nil
        return nil
    }
    
    // MARK: - GCKDiscoveryManagerListener
    
    public func didInsert(_ device: GCKDevice, at index: UInt) { foundDevices[index] = device }
    
    public func didRemove(_ device: GCKDevice, at index: UInt) { foundDevices.removeValue(forKey: index) }
    
    public func didUpdate(_ device: GCKDevice, at index: UInt) {foundDevices[index] = device}
    
    func didUpdateDeviceList() {
        let devices = foundDevices.map{
            device in
            let deviceDictionary: [String: String?] = [
                "id": device.value.uniqueID,
                "name": device.value.friendlyName,
            ]
            return deviceDictionary
        }
        let data = try! JSONEncoder().encode(devices)
        let json = String(data: data, encoding: .utf8)!
        eventSink?(json)
    }
    
}
