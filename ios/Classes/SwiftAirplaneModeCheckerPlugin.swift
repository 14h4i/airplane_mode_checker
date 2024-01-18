import Flutter
import UIKit
import Network
import CoreTelephony

@available(iOS 12.0, *)
public class SwiftAirplaneModeCheckerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "airplane_mode_checker", binaryMessenger: registrar.messenger())
        let instance = SwiftAirplaneModeCheckerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
           
           if (call.method == "checkAirplaneMode") {
               (self.checkAirplaneMode( completion: { (msg) in
                   result(msg)
               }))
           }
           
       }
       
       public override init() {
           super.init()
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
