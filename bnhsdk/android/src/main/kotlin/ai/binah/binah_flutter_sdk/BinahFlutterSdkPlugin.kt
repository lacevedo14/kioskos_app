package ai.binah.binah_flutter_sdk


import ai.binah.sdk.api.HealthMonitorException
import ai.binah.sdk.session.MeasurementMode
import ai.binah.sdk.session.SessionBuilder
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject


class BinahFlutterSdkPlugin: FlutterPlugin, MethodCallHandler {

  private val methodChannelId = "plugins.binah.ai/flutter_plugin"
  private lateinit var channel : MethodChannel
  private lateinit var applicationContext: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelId)
    channel.setMethodCallHandler(this)

    flutterPluginBinding.platformViewRegistry.registerViewFactory(BinahPreviewFactory.cameraPreviewId, BinahPreviewFactory)
    SessionManager.eventChannel = BinahEventChannel(flutterPluginBinding.binaryMessenger, BinahEventChannel.eventChannelId)
    BinahPreviewFactory.setDataSource(SessionManager)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    try {
      when (call.method) {
        NativeBridgeApi.createSession -> {
          SessionManager.createSession(
            applicationContext,
            call.argument<String>("licenseKey") ?: "",
            call.argument<String>("productId"),
            call.argument<Int>("measurementMode"),
            call.argument<Int>("deviceOrientation"),
            call.argument<Int>("subjectSex"),
            call.argument<Double>("subjectAge"),
            call.argument<Double>("subjectWeight"),
            call.argument<Boolean>("detectionAlwaysOn"),
            call.argument<Map<String, Any>>("options")
          )
          result.success(null)
        }
        NativeBridgeApi.startSession -> {
          SessionManager.startSession(call.argument<Int>("duration"))
          result.success(null)
        }
        NativeBridgeApi.stopSession -> {
          SessionManager.stopSession()
          result.success(null)
        }
        NativeBridgeApi.terminateSession -> {
          SessionManager.terminateSession()
          result.success(null)
        }
        NativeBridgeApi.getSessionState -> {
          result.success(SessionManager.getSessionState())
        }
        NativeBridgeApi.getNativeSdkVersion -> {
          result.success(mapOf(
            Pair("version", ai.binah.sdk.BuildConfig.VERSION_NAME),
            Pair("build", ai.binah.sdk.BuildConfig.VERSION_CODE),
          ))
        }
      }
    } catch (e: HealthMonitorException) {
      result.error(e.errorCode.toString(), e.domain, null)
    }
  }
}
