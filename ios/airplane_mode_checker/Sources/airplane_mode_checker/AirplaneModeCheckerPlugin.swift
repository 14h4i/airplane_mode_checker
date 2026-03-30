import CoreTelephony
import Flutter
import UIKit

public class AirplaneModeCheckerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var timer: Timer?

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
      result(isAirplaneModeOn() ? "ON" : "OFF")
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func isAirplaneModeOn() -> Bool {
    let networkInfo = CTTelephonyNetworkInfo()

    if let carriers = networkInfo.serviceSubscriberCellularProviders, !carriers.isEmpty {
      if let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology {
        return radioAccessTechnology.isEmpty
      }
      return true
    }

    // Airplane Mode cannot be detected reliably on devices without cellular radios.
    return false
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    startMonitoring()
    events(isAirplaneModeOn() ? "ON" : "OFF")
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
      guard let self, let eventSink = self.eventSink else { return }
      eventSink(self.isAirplaneModeOn() ? "ON" : "OFF")
    }

    if let timer {
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
}
