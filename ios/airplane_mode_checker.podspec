#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint airplane_mode_checker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'airplane_mode_checker'
  s.version          = '3.3.0'
  s.summary          = 'Flutter plugin to check Airplane Mode status on iOS and Android.'
  s.description      = <<-DESC
A Flutter plugin that allows you to check the status of Airplane Mode on iOS and Android mobile devices.
Supports both one-time checks and continuous monitoring via streams.
                       DESC
  s.homepage         = 'https://github.com/14h4i/airplane_mode_checker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { '14h4i' => 'https://github.com/14h4i' }
  s.source           = { :path => '.' }
  s.source_files = 'airplane_mode_checker/Sources/airplane_mode_checker/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
