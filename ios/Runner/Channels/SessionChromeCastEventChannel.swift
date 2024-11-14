import GoogleCast

class SessionChromeCastEventChannel : NSObject, GCKSessionManagerListener, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var foundDevices: [GCKDevice] = []
    private var currentSession : GCKSessionManager  {
        GCKCastContext.sharedInstance().sessionManager
    }
    
    // MARK: - FlutterStreamHandler
    
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        currentSession.add(self)
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        currentSession.remove(self)
        eventSink = nil
        return nil
    }
    
    // MARK: - GCKSessionManagerListener
    
    public func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        updateSessionState(session)
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager, willStart session: GCKCastSession) {
        updateSessionState(session)
        
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager, didFailToStart session: GCKCastSession, withError error: Error) {
        updateSessionState(session)
        
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager, willEnd session: GCKSession) {
        updateSessionState(session)
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        updateSessionState(session)
    }
    
    private func updateSessionState(_ session : GCKSession?) {
        let connectionState = session?.connectionState
        let currentState = switch connectionState {
        case .connected:
            "connected"
        case .connecting:
            "connecting"
        case .disconnecting:
           "disconnecting"
        default:
            "disconnected"
        }
        eventSink?(currentState)
    }
}
