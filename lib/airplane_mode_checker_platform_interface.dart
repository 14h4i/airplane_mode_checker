import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'airplane_mode_checker_method_channel.dart';

abstract class AirplaneModeCheckerPlatform extends PlatformInterface {
  /// Constructs a AirplaneModeCheckerPlatform.
  AirplaneModeCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static AirplaneModeCheckerPlatform _instance =
      MethodChannelAirplaneModeChecker();

  /// The default instance of [AirplaneModeCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelAirplaneModeChecker].
  static AirplaneModeCheckerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AirplaneModeCheckerPlatform] when
  /// they register themselves.
  static set instance(AirplaneModeCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<String?> checkAirplaneMode() {
    throw UnimplementedError('checkAirplaneMode() has not been implemented.');
  }

  Stream<String> listenAirplaneMode() {
    throw UnimplementedError('listenAirplaneMode() has not been implemented.');
  }
}
