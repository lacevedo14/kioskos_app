package ai.binah.binah_flutter_sdk

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class BinahEventChannel(
    messenger: BinaryMessenger,
    name: String
): EventChannel.StreamHandler {

    companion object {
        const val eventChannelId = "plugins.binah.ai/sdk_events"
    }

    private var eventSink: EventChannel.EventSink?  = null
    private val mainScope = CoroutineScope(Dispatchers.Main)

    init {
        val channel = EventChannel(messenger, name)
        channel.setStreamHandler(this)
    }

    fun sendEvent(name: String, payload: Any) {
        eventSink?.let { sink ->
            mainScope.launch {
                sink.success(mapOf(
                    Pair("event", name),
                    Pair("payload", payload)
                ))
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

}