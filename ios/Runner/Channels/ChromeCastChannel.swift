import Foundation
import GoogleCast

class ChromeCastChannel {
    private lazy var currentRemoteMediaClient: GCKRemoteMediaClient? = {
        GCKCastContext.sharedInstance().sessionManager.currentSession?.remoteMediaClient
    }()
    
    private lazy var currentSession: GCKSession? = {
        return GCKCastContext.sharedInstance().sessionManager.currentSession
    }()
    
    private lazy var sessionManager: GCKSessionManager = {
        return GCKCastContext.sharedInstance().sessionManager
    }()
    
    private var discoveryManager: GCKDiscoveryManager{
        GCKCastContext.sharedInstance().discoveryManager
    }
    
    func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        switch call.method {
        case "start_device":
            startDevice(deviceId: call.arguments as! String, result: result)
        case "set_media":
            setMedia(data: call.arguments as! Dictionary<String, Any>, result: result)
        case "seek":
            seek(position: call.arguments as! Int, result: result)
        case "play":
            play(result: result)
        case "pause":
            pause(result: result)
        case "disconnect_device":
            disconnectDevice(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startDevice(deviceId: String, result: FlutterResult) {
        let device = discoveryManager.device(withUniqueID: deviceId)
        sessionManager.startSession(with: device!)
        result(true)
    }
    
    private func setMedia(data : Dictionary<String, Any>, result: FlutterResult) {
        let url = data["url"] as? String ?? ""
        let contentType = data["content_type"] as? String ?? "videos/mp4"
        let isPlaying = data["is_playing"] as? Bool ?? true
        let playPosition = data["play_position"] as? Int ?? 0
        
        let mediaInfo = GCKMediaInformationBuilder(contentURL: URL(string: url)!)
        mediaInfo.streamType = GCKMediaStreamType.buffered
        mediaInfo.contentType = contentType
        
        let loadOptions = GCKMediaLoadOptions()
        loadOptions.autoplay = isPlaying
        loadOptions.playPosition = TimeInterval(playPosition)
        
        currentRemoteMediaClient?.loadMedia(mediaInfo.build(), with:loadOptions)
        result(nil)
    }
    
    private func play(result: FlutterResult) {
        currentRemoteMediaClient?.play()
        result(nil)
    }
    
    private func pause(result: FlutterResult) {
        currentRemoteMediaClient?.pause()
        result(nil)
    }
    
    private func seek(position: Int, result: FlutterResult) {
        let seekOptions = GCKMediaSeekOptions.init()
        seekOptions.interval = TimeInterval(position)
        currentRemoteMediaClient?.seek(with: seekOptions)
        result(nil)
    }
    
    private func disconnectDevice(result: FlutterResult) {
        sessionManager.endSessionAndStopCasting(true)
        result(nil)
    }
    
}
