import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:airplane_mode_checker/airplane_mode_checker_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAirplaneModeChecker platform =
      MethodChannelAirplaneModeChecker();
  const MethodChannel channel = MethodChannel('airplane_mode_checker');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getPlatformVersion':
            return '42';
          case 'checkAirplaneMode':
            return 'OFF';
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('checkAirplaneMode', () async {
    expect(await platform.checkAirplaneMode(), 'OFF');
  });
}
