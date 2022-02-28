import 'dart:async';

import 'package:flutter/services.dart';

enum AirplaneModeStatus { on, off }

class AirplaneModeChecker {
  static const MethodChannel _channel = MethodChannel('airplane_mode_checker');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<AirplaneModeStatus> checkAirplaneMode() async {
    AirplaneModeStatus airplaneModeStatus = AirplaneModeStatus.off;
    final String airplanemode =
        await _channel.invokeMethod('checkAirplaneMode');
    if (airplanemode == 'ON') {
      airplaneModeStatus = AirplaneModeStatus.on;
    } else if (airplanemode == 'OFF') {
      airplaneModeStatus = AirplaneModeStatus.off;
    }
    return airplaneModeStatus;
  }
}
