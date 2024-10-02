package com.u14h4i.airplane_mode_checker

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AirplaneModeCheckerPlugin */
class AirplaneModeCheckerPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var context: Context
  private var eventSink: EventChannel.EventSink? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "airplane_mode_checker")
    methodChannel.setMethodCallHandler(this)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "airplane_mode_checker_stream")
    eventChannel.setStreamHandler(this)
    context = flutterPluginBinding.applicationContext

    // Check initial airplane mode status
    checkInitialAirplaneMode()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
      "checkAirplaneMode" -> {
        if (isAirModeOn()) result.success("ON") else result.success("OFF")
      }
      else -> result.notImplemented()
    }
  }

  private fun isAirModeOn(): Boolean {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      Settings.Global.getInt(context.contentResolver, Settings.Global.AIRPLANE_MODE_ON, 0) == 1
    } else {
      Settings.System.getInt(context.contentResolver, Settings.System.AIRPLANE_MODE_ON, 0) == 1
    }
  }

  private fun checkInitialAirplaneMode() {
      val isAirplaneModeOn = isAirModeOn()
      eventSink?.success(if (isAirplaneModeOn) "ON" else "OFF")
    }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
    val filter = IntentFilter(Intent.ACTION_AIRPLANE_MODE_CHANGED)
    context.registerReceiver(airplaneModeReceiver, filter)
    // Emit initial status
    checkInitialAirplaneMode()
  }

  override fun onCancel(arguments: Any?) {
    context.unregisterReceiver(airplaneModeReceiver)
    eventSink = null
  }

  private val airplaneModeReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
      val isAirplaneModeOn = isAirModeOn()
      eventSink?.success(if (isAirplaneModeOn) "ON" else "OFF")
}
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }
}