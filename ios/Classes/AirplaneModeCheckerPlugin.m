#import "AirplaneModeCheckerPlugin.h"
#if __has_include(<airplane_mode_checker/airplane_mode_checker-Swift.h>)
#import <airplane_mode_checker/airplane_mode_checker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "airplane_mode_checker-Swift.h"
#endif

@implementation AirplaneModeCheckerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAirplaneModeCheckerPlugin registerWithRegistrar:registrar];
}
@end
