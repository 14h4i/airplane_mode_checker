import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'airplane_mode_checker_platform_interface.dart';

/// An implementation of [AirplaneModeCheckerPlatform] that uses method channels.
class MethodChannelAirplaneModeChecker extends AirplaneModeCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('airplane_mode_checker');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> checkAirplaneMode() async {
    final version =
        await methodChannel.invokeMethod<String>('checkAirplaneMode');
    return version;
  }
}
