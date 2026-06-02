import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:airplane_mode_checker/airplane_mode_checker_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAirplaneModeChecker platform =
      MethodChannelAirplaneModeChecker();
  const MethodChannel channel = MethodChannel('airplane_mode_checker');
  const EventChannel eventChannel = EventChannel(
    'airplane_mode_checker_stream',
  );
  const MethodCodec codec = StandardMethodCodec();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(eventChannel.name, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('checkAirplaneMode forwards defaultValue', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          expect(methodCall.method, 'checkAirplaneMode');
          expect(methodCall.arguments, <String, String>{'defaultValue': 'ON'});
          return 'ON';
        });

    expect(await platform.checkAirplaneMode(defaultValue: 'ON'), 'ON');
  });

  test('listenAirplaneMode forwards defaultValue', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(eventChannel.name, (ByteData? message) async {
          final methodCall = codec.decodeMethodCall(message);
          if (methodCall.method == 'listen') {
            expect(methodCall.arguments, <String, String>{
              'defaultValue': 'ON',
            });
          }
          return codec.encodeSuccessEnvelope(null);
        });

    final subscription = platform
        .listenAirplaneMode(defaultValue: 'ON')
        .listen((_) {});

    await subscription.cancel();
  });
}
