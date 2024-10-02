import Flutter
import UIKit
import CoreTelephony

public class AirplaneModeCheckerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var timer: Timer?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "airplane_mode_checker", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "airplane_mode_checker_stream", binaryMessenger: registrar.messenger())
    let instance = AirplaneModeCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)

    // Check initial airplane mode status
    instance.checkInitialAirplaneMode()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "checkAirplaneMode":
      self.checkAirplaneMode { (msg) in
            result(msg)
    }
    default:
      result(FlutterMethodNotImplemented)
  }
  }
    
  func checkAirplaneMode(completion: @escaping (String) -> Void) {
    let msg = self.isAirplaneModeOn() ? "ON" : "OFF"
        completion(msg)
    }

    func isAirplaneModeOn() -> Bool {
        let networkInfo = CTTelephonyNetworkInfo()
           guard let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology else {
           return false
       }
       return radioAccessTechnology.isEmpty
    }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    self.startMonitoring()
    return nil
}

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    self.stopMonitoring()
    return nil
  }

  private func startMonitoring() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      if let eventSink = self.eventSink {
        let msg = self.isAirplaneModeOn() ? "ON" : "OFF"
        eventSink(msg)
      }
    }
  }

  private func stopMonitoring() {
    timer?.invalidate()
    timer = nil
  }

  private func checkInitialAirplaneMode() {
    let msg = self.isAirplaneModeOn() ? "ON" : "OFF"
    self.eventSink?(msg)
}
}