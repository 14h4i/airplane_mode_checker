import 'dart:async';

import 'package:flutter/services.dart';

class AirplaneModeChecker {
  static const MethodChannel _channel = MethodChannel('airplane_mode_checker');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> checkAirplaneMode() async {
    final String airplanemode =
        await _channel.invokeMethod('checkAirplaneMode');
    return airplanemode;
  }
}
