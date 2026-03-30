import CoreTelephony
import Flutter
import UIKit

public class AirplaneModeCheckerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var timer: Timer?
  private var streamDefaultValue = false

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "airplane_mode_checker", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "airplane_mode_checker_stream", binaryMessenger: registrar.messenger())
    let instance = AirplaneModeCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "checkAirplaneMode":
      let defaultValue = self.defaultValue(from: call.arguments)
      self.checkAirplaneMode(defaultValue: defaultValue) { (msg) in
        result(msg)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func checkAirplaneMode(defaultValue: Bool, completion: @escaping (String) -> Void) {
    let msg = self.isAirplaneModeOn(defaultValue: defaultValue) ? "ON" : "OFF"
    completion(msg)
  }

  func isAirplaneModeOn(defaultValue: Bool) -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()

    if let carriers = networkInfo.serviceSubscriberCellularProviders, !carriers.isEmpty {
      if let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology {
        return radioAccessTechnology.isEmpty
      }
      return true
    }
    // Airplane Mode cannot be detected reliably on devices without cellular radios.
    return defaultValue
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    streamDefaultValue = defaultValue(from: arguments)
    startMonitoring()

    let msg = isAirplaneModeOn(defaultValue: streamDefaultValue) ? "ON" : "OFF"
    events(msg)
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    stopMonitoring()
    eventSink = nil
    return nil
  }

  private func startMonitoring() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self, let eventSink = self.eventSink else { return }
      let msg = self.isAirplaneModeOn(defaultValue: self.streamDefaultValue) ? "ON" : "OFF"
      eventSink(msg)
    }

    if let timer = timer {
      RunLoop.current.add(timer, forMode: .common)
    }
  }

  private func stopMonitoring() {
    timer?.invalidate()
    timer = nil
  }

  deinit {
    stopMonitoring()
  }

  private func defaultValue(from arguments: Any?) -> Bool {
    guard
      let arguments = arguments as? [String: Any],
      let defaultValue = arguments["defaultValue"] as? String
    else {
      return false
    }

    return defaultValue == "ON"
  }
}
