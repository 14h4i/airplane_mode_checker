package com.u14h4i.airplane_mode_checker

import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AirplaneModeCheckerPlugin */
class AirplaneModeCheckerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var mFlutterPluginBinding: FlutterPlugin.FlutterPluginBinding

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "airplane_mode_checker")
    channel.setMethodCallHandler(this)
    mFlutterPluginBinding = flutterPluginBinding
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method.equals("checkAirplaneMode")) {
      if (isAirModeOn()!!) result.success("ON") else result.success("OFF")
    } else {
      result.notImplemented()
    }
  }

  private fun isAirModeOn(): Boolean? {
    val isAirplaneMode: Boolean = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      Settings.Global.getInt(mFlutterPluginBinding.getApplicationContext().getContentResolver(),
              Settings.Global.AIRPLANE_MODE_ON, 0) == 1
    } else {
      Settings.System.getInt(mFlutterPluginBinding.getApplicationContext().getContentResolver(),
              Settings.System.AIRPLANE_MODE_ON, 0) == 1
    }
    return isAirplaneMode
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}