import Flutter
import UIKit
import CoreTelephony
import Network

public class AirplaneModeCheckerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var timer: Timer?
  private var pathMonitor: NWPathMonitor?
  private var streamDefaultValue = false
  private let monitorQueue = DispatchQueue(label: "com.u14h4i.airplane_mode_checker.monitor")

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
    // Check using CTTelephonyNetworkInfo for cellular radio
    let networkInfo = CTTelephonyNetworkInfo()
    
    // For devices with cellular capability
    if let carriers = networkInfo.serviceSubscriberCellularProviders, !carriers.isEmpty {
      // If we have carrier info but no radio access technology, airplane mode might be on
      if let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology {
        // If the dictionary exists but is empty, airplane mode is likely on
        return radioAccessTechnology.isEmpty
      }
      // If radioAccessTechnology is nil but we have carriers, airplane mode might be on
      return true
    }
    
    // For WiFi-only devices (iPad WiFi, iPod Touch), we can't reliably detect airplane mode
    // Return the caller-provided default for non-cellular devices
    return defaultValue
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    self.streamDefaultValue = self.defaultValue(from: arguments)
    self.startMonitoring()
    
    // Send initial status
    let msg = self.isAirplaneModeOn(defaultValue: self.streamDefaultValue) ? "ON" : "OFF"
    events(msg)
    
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.stopMonitoring()
    self.eventSink = nil
    return nil
  }

  private func startMonitoring() {
    // Use timer-based monitoring for airplane mode changes
    // Network framework could be used for network availability, but airplane mode
    // specifically requires polling or listening to system notifications
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self = self, let eventSink = self.eventSink else { return }
      let msg = self.isAirplaneModeOn(defaultValue: self.streamDefaultValue) ? "ON" : "OFF"
      eventSink(msg)
    }
    
    // Ensure timer runs even when UI is being interacted with
    if let timer = timer {
      RunLoop.current.add(timer, forMode: .common)
    }
  }

  private func stopMonitoring() {
    timer?.invalidate()
    timer = nil
    pathMonitor?.cancel()
    pathMonitor = nil
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
