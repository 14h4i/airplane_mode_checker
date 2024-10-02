import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:airplane_mode_checker/airplane_mode_checker_method_channel.dart';
import 'package:airplane_mode_checker/airplane_mode_checker_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAirplaneModeCheckerPlatform
    with MockPlatformInterfaceMixin
    implements AirplaneModeCheckerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> checkAirplaneMode() => Future.value('ON');

  @override
  Stream<String> listenAirplaneMode() {
    return Stream.value('ON');
  }
}

void main() {
  final AirplaneModeCheckerPlatform initialPlatform =
      AirplaneModeCheckerPlatform.instance;

  test('$MethodChannelAirplaneModeChecker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAirplaneModeChecker>());
  });

  test('getPlatformVersion', () async {
    AirplaneModeChecker airplaneModeCheckerPlugin =
        AirplaneModeChecker.instance;
    MockAirplaneModeCheckerPlatform fakePlatform =
        MockAirplaneModeCheckerPlatform();
    AirplaneModeCheckerPlatform.instance = fakePlatform;

    expect(await airplaneModeCheckerPlugin.getPlatformVersion(), '42');
  });

  test('checkAirplaneMode', () async {
    AirplaneModeChecker airplaneModeCheckerPlugin =
        AirplaneModeChecker.instance;
    MockAirplaneModeCheckerPlatform fakePlatform =
        MockAirplaneModeCheckerPlatform();
    AirplaneModeCheckerPlatform.instance = fakePlatform;

    expect(await airplaneModeCheckerPlugin.checkAirplaneMode(),
        AirplaneModeStatus.on);
  });

  test('listenAirplaneMode', () async {
    AirplaneModeChecker airplaneModeCheckerPlugin =
        AirplaneModeChecker.instance;
    MockAirplaneModeCheckerPlatform fakePlatform =
        MockAirplaneModeCheckerPlatform();
    AirplaneModeCheckerPlatform.instance = fakePlatform;

    airplaneModeCheckerPlugin.listenAirplaneMode().listen((event) {
      expect(event, AirplaneModeStatus.on);
    });
  });
}
