//
//  AppDelegate 2.swift
//  Runner
//
//  Created by Kauê Martins on 12/11/24.
//


import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let chromeCastChannelName = "br.com.ziyou/chromecast"
    private let sessionChromeCastChannelName = "br.com.ziyou/chromecast_session"
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let binnaryMessenger = controller.binaryMessenger
                let batteryChannel = FlutterMethodChannel(name: chromeCastChannelName, binaryMessenger: binnaryMessenger)
      
      //let instance = ChromeCastChannel()
      
//      instance.channel = FlutterMethodChannel(name: "google_cast.remote_media_client", binaryMessenger: registrar.messenger())
//      
//      registrar.addMethodCallDelegate(instance, channel: instance.channel!)
//      
//      batteryChannel.setMethodCallHandler({
//        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//        // This method is invoked on the UI thread.
//        guard call.method == "getBatteryLevel" else {
//          result(FlutterMethodNotImplemented)
//          return
//        }
//        self?.receiveBatteryLevel(result: result)
//      })
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
