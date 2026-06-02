import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:airplane_mode_checker/airplane_mode_checker_method_channel.dart';
import 'package:airplane_mode_checker/airplane_mode_checker_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAirplaneModeCheckerPlatform
    with MockPlatformInterfaceMixin
    implements AirplaneModeCheckerPlatform {
  String? checkDefaultValue;
  String? listenDefaultValue;

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> checkAirplaneMode({String defaultValue = 'OFF'}) {
    checkDefaultValue = defaultValue;
    return Future.value('ON');
  }

  @override
  Stream<String> listenAirplaneMode({String defaultValue = 'OFF'}) {
    listenDefaultValue = defaultValue;
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

    expect(
      await airplaneModeCheckerPlugin.checkAirplaneMode(),
      AirplaneModeStatus.on,
    );
  });

  test('checkAirplaneMode forwards defaultValue', () async {
    AirplaneModeChecker airplaneModeCheckerPlugin =
        AirplaneModeChecker.instance;
    MockAirplaneModeCheckerPlatform fakePlatform =
        MockAirplaneModeCheckerPlatform();
    AirplaneModeCheckerPlatform.instance = fakePlatform;

    expect(
      await airplaneModeCheckerPlugin.checkAirplaneMode(
        defaultValue: AirplaneModeStatus.on,
      ),
      AirplaneModeStatus.on,
    );
    expect(fakePlatform.checkDefaultValue, 'ON');
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

  test('listenAirplaneMode forwards defaultValue', () async {
    AirplaneModeChecker airplaneModeCheckerPlugin =
        AirplaneModeChecker.instance;
    MockAirplaneModeCheckerPlatform fakePlatform =
        MockAirplaneModeCheckerPlatform();
    AirplaneModeCheckerPlatform.instance = fakePlatform;

    await expectLater(
      airplaneModeCheckerPlugin.listenAirplaneMode(
        defaultValue: AirplaneModeStatus.on,
      ),
      emits(AirplaneModeStatus.on),
    );
    expect(fakePlatform.listenDefaultValue, 'ON');
  });
}
