import Flutter
import UIKit
import Network
import CoreTelephony

public class AirplaneModeCheckerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "airplane_mode_checker", binaryMessenger: registrar.messenger())
    let instance = AirplaneModeCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "checkAirplaneMode":
        (self.checkAirplaneMode( completion: { (msg) in
            result(msg)
        }))
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    func checkAirplaneMode(completion: @escaping (String) -> Void){
        
        var msg: String = ""
        
        if (self.isAirplaneModeOn()) {
            msg = "ON"
        } else {
            msg = "OFF"
        }
        
        completion(msg)
        
    }

    func isAirplaneModeOn() -> Bool {
        let networkInfo = CTTelephonyNetworkInfo()
           guard let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology else {
           return false
       }
       return radioAccessTechnology.isEmpty
    }
}
