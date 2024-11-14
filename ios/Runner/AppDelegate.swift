import Flutter
import UIKit
import GoogleCast

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let chromeCastChannelName = "br.com.ziyou/player_chrome_cast"
    private let sessionChromeCastChannelName = "br.com.ziyou/chrome_cast_session"
    private let discoveryChromeCastChannelName = "br.com.ziyou/discovery_chrome_cast"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let binnaryMessenger = controller.binaryMessenger
        GCKCastContext.setSharedInstanceWith(GCKCastOptions(discoveryCriteria: GCKDiscoveryCriteria(applicationID: "CC1AD845")))
        
        let chromeCastFlutterChannel = FlutterMethodChannel(name: chromeCastChannelName, binaryMessenger: binnaryMessenger)
        let chromeCastChannel = ChromeCastChannel()
        chromeCastFlutterChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            chromeCastChannel.handleMethodCall(call: call, result: result)
        })
        
        let discoveryFlutterChannel = FlutterEventChannel(name: discoveryChromeCastChannelName, binaryMessenger: binnaryMessenger)
        discoveryFlutterChannel.setStreamHandler(DiscoveryChromeCastEventChannel())
        
        let sessionChromeCastFlutterChannel = FlutterEventChannel(name: sessionChromeCastChannelName, binaryMessenger: binnaryMessenger)
        sessionChromeCastFlutterChannel.setStreamHandler(SessionChromeCastEventChannel())
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
}
