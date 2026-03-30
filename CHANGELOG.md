## 3.3.0

**Updates:**

- **iOS / Swift Package Manager:**
  - Added Swift Package Manager support for the iOS plugin
  - Moved iOS sources to the Swift Package Manager layout
  - Updated minimum iOS version to 13.0

- **Documentation and examples:**
  - Clarified iOS polling behavior for `listenAirplaneMode()`
  - Fixed README usage examples to match the actual singleton API
  - Updated the example README and fixed stale example widget tests

- **Tests and maintenance:**
  - Added more Dart tests for `OFF`, `null`, and stream mapping cases
  - Improved Android stream lifecycle cleanup
  - Removed unused iOS implementation pieces

## 0.0.1

- Flutter plugin for check airplane mode

## 1.0.0

- Publishing plugin

## 1.0.1

- Update SwiftAirplaneModeCheckerPlugin.swift

## 1.0.2

- Update readme

## 1.0.3

- Update readme

## 1.0.4

- Turn private AirplaneModeChecker constructor (PR https://github.com/14h4i/airplane_mode_checker/pull/6)

## 1.0.5

- Remove print on iOS and clean up native code (PR https://github.com/14h4i/airplane_mode_checker/pull/8)
  Thanks @stefanschaller

## 2.0.0

**Updates:**

- Android Gradle plugin (AGP)
- Gradle wrapper
- Kotlin version
- compileSdkVersion
- Update dependencies

## 2.1.0

**Updates:**

- Logic check airplane for IOS
- Issue (https://github.com/14h4i/airplane_mode_checker/issues/11)

## 2.2.0

**Updates:**

- Moved dependency 'fluttertoast' to example folder (https://github.com/14h4i/airplane_mode_checker/pull/14)

## 3.0.0

**Updates:**

- Migrate to new base
- Add `namespace` - Support for AGP Version (https://github.com/14h4i/airplane_mode_checker/issues/15)

## 3.1.0

**Updates:**

- New feature `AirplaneModeChecker.instance.listenAirplaneMode()` for request (https://github.com/14h4i/airplane_mode_checker/issues/16)

## 3.2.0

**Updates:**

- **iOS improvements:**
  - Fixed airplane mode detection logic for better accuracy on cellular devices
  - Added proper memory leak prevention with deinit
  - Improved timer handling to work correctly during UI interactions
  - Added Network framework import for future enhancements
  - Better handling of WiFi-only devices (iPad WiFi, iPod Touch)
  - Updated minimum iOS version to 12.0

- **Android improvements:**
  - Updated Gradle to 8.2.2 (from 7.3.0)
  - Updated Kotlin to 1.9.22 (from 1.7.10)
  - Updated compileSdk to 35 (Android 15)
  - Updated Mockito to 5.10.0 for better testing

- **General improvements:**
  - Updated plugin_platform_interface to ^2.1.0
  - Added package topics for better discoverability on pub.dev
  - Improved code quality and documentation
  - Updated podspec with proper metadata
