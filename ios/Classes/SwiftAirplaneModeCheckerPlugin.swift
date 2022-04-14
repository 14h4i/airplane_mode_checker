import Flutter
import UIKit
import Network

@available(iOS 12.0, *)
public class SwiftAirplaneModeCheckerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "airplane_mode_checker", binaryMessenger: registrar.messenger())
    let instance = SwiftAirplaneModeCheckerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion"){
                  result("iOS" + UIDevice.current.systemVersion)
              }

     else if (call.method == "checkAirplaneMode") {
      (self.checkAirplaneMode( completion: { (msg) in
          result(msg)
      }))
      }

      }

            public override init() {
                  super.init()
              }


      func checkAirplaneMode(completion: @escaping (String) -> Void){
          let monitor = NWPathMonitor()
          var msg: String = ""


          monitor.pathUpdateHandler = { path in
              if path.availableInterfaces.count == 0{
                  msg = "ON"
                  print("Flight Mode")
                  monitor.cancel()

              }
              else {
                  msg = "OFF"
                  print("Not Flight Mode")
                  monitor.cancel()

              }
              completion(msg)
          }

          let queue = DispatchQueue(label: "Monitor", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
          monitor.start(queue: queue)
      
  }
}
