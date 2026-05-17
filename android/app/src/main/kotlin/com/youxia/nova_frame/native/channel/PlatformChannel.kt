package com.youxia.nova_frame.native.channel
import android.content.Context
import android.os.Build
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PlatformChannel(
    @Suppress("UNUSED_PARAMETER") private val context: Context,
    private val messenger: BinaryMessenger,
    private val channelName: String = CHANNEL_NAME,
) : MethodChannel.MethodCallHandler {

    private val channel: MethodChannel = MethodChannel(messenger, channelName)

    fun register() {
        channel.setMethodCallHandler(this)
    }

    fun unregister() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_PLATFORM_VERSION -> {
                val version = "Android ${Build.VERSION.RELEASE} (SDK ${Build.VERSION.SDK_INT})"
                result.success(version)
            }

            else -> result.notImplemented()
        }
    }

    companion object {
        const val CHANNEL_NAME = "nova/platform"
        const val METHOD_GET_PLATFORM_VERSION = "getPlatformVersion"
    }
}

