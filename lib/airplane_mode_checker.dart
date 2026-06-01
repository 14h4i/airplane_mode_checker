import 'airplane_mode_checker_platform_interface.dart';

enum AirplaneModeStatus { on, off }

class AirplaneModeChecker {
  AirplaneModeChecker._();
  static final AirplaneModeChecker _instance = AirplaneModeChecker._();

  static AirplaneModeChecker get instance => _instance;

  Future<String?> getPlatformVersion() {
    return AirplaneModeCheckerPlatform.instance.getPlatformVersion();
  }

  Future<AirplaneModeStatus> checkAirplaneMode({
    AirplaneModeStatus defaultValue = AirplaneModeStatus.off,
  }) async {
    final mode = await AirplaneModeCheckerPlatform.instance.checkAirplaneMode(
      defaultValue: _stringFromAirplaneModeStatus(defaultValue),
    );
    return _airplaneModeStatusFromString(mode);
  }

  Stream<AirplaneModeStatus> listenAirplaneMode({
    AirplaneModeStatus defaultValue = AirplaneModeStatus.off,
  }) {
    return AirplaneModeCheckerPlatform.instance
        .listenAirplaneMode(
          defaultValue: _stringFromAirplaneModeStatus(defaultValue),
        )
        .map(_airplaneModeStatusFromString);
  }

  String _stringFromAirplaneModeStatus(AirplaneModeStatus status) {
    return status == AirplaneModeStatus.on ? 'ON' : 'OFF';
  }

  AirplaneModeStatus _airplaneModeStatusFromString(String? status) {
    return status == 'ON' ? AirplaneModeStatus.on : AirplaneModeStatus.off;
  }
}
