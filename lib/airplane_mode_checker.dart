import 'airplane_mode_checker_platform_interface.dart';

enum AirplaneModeStatus { on, off }

class AirplaneModeChecker {
  AirplaneModeChecker._();
  static final AirplaneModeChecker _instance = AirplaneModeChecker._();

  static AirplaneModeChecker get instance => _instance;

  Future<String?> getPlatformVersion() {
    return AirplaneModeCheckerPlatform.instance.getPlatformVersion();
  }

  Future<AirplaneModeStatus> checkAirplaneMode() async {
    final mode = await AirplaneModeCheckerPlatform.instance.checkAirplaneMode();

    if (mode == 'ON') {
      return AirplaneModeStatus.on;
    }

    return AirplaneModeStatus.off;
  }
}
