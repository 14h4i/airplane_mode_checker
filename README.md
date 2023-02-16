# AirplaneModeChecker

---

[![Pub](https://img.shields.io/pub/v/airplane_mode_checker.svg)](https://pub.dev/packages/airplane_mode_checker)

A Flutter plugin allows you to check the status of Airplane Mode on iOS and Android mobile.

## Usage

Find the example wiring in the [example app](https://github.com/14h4i/airplane_mode_checker/blob/master/example/lib/main.dart)

### Installation

Add the following line to `pubspec.yaml`:

```yaml
dependencies:
  airplane_mode_checker: ^1.0.4
```

Add the following import to your Dart code:

```dart
import 'package:airplane_mode_checker/airplane_mode_checker.dart';
```

### Check Airplane Mode

In order to check the airplane mode, use `AirplaneModeChecker.checkAirplaneMode()` as below.

You will get the return `AirplaneModeStatus`:

- `AirplaneModeStatus.on`
- `AirplaneModeStatus.off`

```dart
final status = await AirplaneModeChecker.checkAirplaneMode();
```

## iOS available

iOS is available from version 12

```swift
@available(iOS 12.0, *)
```

## ScreenShots

> ### Android
>
> | <img src="https://raw.githubusercontent.com/14h4i/airplane_mode_checker/master/screenshots/on.jpg" width="360" /> | <img src="https://raw.githubusercontent.com/14h4i/airplane_mode_checker/master/screenshots/off.jpg" width="360" /> |
> | :---------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------------: |
> |                                                AirplaneMode: `ON`                                                 |                                                AirplaneMode: `OFF`                                                 |

## Issues and feedback

Please file [issues](https://github.com/14h4i/airplane_mode_checker/issues) to send feedback or report a bug. Thank you!

## License

[MIT](https://mit-license.org) License

<a href="https://www.buymeacoffee.com/14h4i" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>
