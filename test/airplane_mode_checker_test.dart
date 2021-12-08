import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';

void main() {
  const MethodChannel channel = MethodChannel('airplane_mode_checker');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AirplaneModeChecker.platformVersion, '42');
  });
}
