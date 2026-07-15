import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:airplane_mode_checker/airplane_mode_checker_method_channel.dart';
import 'package:airplane_mode_checker/airplane_mode_checker_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAirplaneModeCheckerPlatform
    with MockPlatformInterfaceMixin
    implements AirplaneModeCheckerPlatform {
  MockAirplaneModeCheckerPlatform({
    this.platformVersion = '42',
    this.airplaneMode = 'ON',
    Stream<String>? stream,
  }) : _stream = stream ?? Stream.value('ON');

  final String? platformVersion;
  final String? airplaneMode;
  final Stream<String> _stream;
  String? checkDefaultValue;
  String? listenDefaultValue;

  @override
  Future<String?> getPlatformVersion() => Future.value(platformVersion);

  @override
  Future<String?> checkAirplaneMode({String defaultValue = 'OFF'}) {
    checkDefaultValue = defaultValue;
    return Future.value(airplaneMode);
  }

  @override
  Stream<String> listenAirplaneMode({String defaultValue = 'OFF'}) {
    listenDefaultValue = defaultValue;
    return _stream;
  }
}

void main() {
  final AirplaneModeCheckerPlatform initialPlatform =
      AirplaneModeCheckerPlatform.instance;

  tearDown(() {
    AirplaneModeCheckerPlatform.instance = initialPlatform;
  });

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

  test('checkAirplaneMode maps OFF to AirplaneModeStatus.off', () async {
    AirplaneModeChecker airplaneModeCheckerPlugin =
        AirplaneModeChecker.instance;
    MockAirplaneModeCheckerPlatform fakePlatform =
        MockAirplaneModeCheckerPlatform(airplaneMode: 'OFF');
    AirplaneModeCheckerPlatform.instance = fakePlatform;

    expect(
      await airplaneModeCheckerPlugin.checkAirplaneMode(),
      AirplaneModeStatus.off,
    );
  });

  test('checkAirplaneMode maps null to AirplaneModeStatus.off', () async {
    AirplaneModeChecker airplaneModeCheckerPlugin =
        AirplaneModeChecker.instance;
    MockAirplaneModeCheckerPlatform fakePlatform =
        MockAirplaneModeCheckerPlatform(airplaneMode: null);
    AirplaneModeCheckerPlatform.instance = fakePlatform;

    expect(
      await airplaneModeCheckerPlugin.checkAirplaneMode(),
      AirplaneModeStatus.off,
    );
  });

  test('listenAirplaneMode', () async {
    AirplaneModeChecker airplaneModeCheckerPlugin =
        AirplaneModeChecker.instance;
    MockAirplaneModeCheckerPlatform fakePlatform =
        MockAirplaneModeCheckerPlatform();
    AirplaneModeCheckerPlatform.instance = fakePlatform;

    expect(
      airplaneModeCheckerPlugin.listenAirplaneMode(),
      emits(AirplaneModeStatus.on),
    );
  });

  test(
    'listenAirplaneMode maps non-ON events to AirplaneModeStatus.off',
    () async {
      AirplaneModeChecker airplaneModeCheckerPlugin =
          AirplaneModeChecker.instance;
      MockAirplaneModeCheckerPlatform fakePlatform =
          MockAirplaneModeCheckerPlatform(
            stream: Stream<String>.fromIterable(['OFF', 'UNKNOWN', 'ON']),
          );
      AirplaneModeCheckerPlatform.instance = fakePlatform;

      expect(
        airplaneModeCheckerPlugin.listenAirplaneMode(),
        emitsInOrder([
          AirplaneModeStatus.off,
          AirplaneModeStatus.off,
          AirplaneModeStatus.on,
        ]),
      );
    },
  );

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
