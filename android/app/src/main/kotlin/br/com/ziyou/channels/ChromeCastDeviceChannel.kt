package br.com.ziyou.channels

import android.content.Context
import androidx.mediarouter.media.MediaRouter
import com.google.android.gms.cast.CastDevice
import com.google.android.gms.cast.MediaInfo
import com.google.android.gms.cast.MediaLoadOptions
import com.google.android.gms.cast.MediaSeekOptions
import com.google.android.gms.cast.framework.CastContext
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

@Suppress("UNCHECKED_CAST")
class ChromeCastPlayerChannel(private val context: Context) {
    private val currentSession
        get() = CastContext.getSharedInstance(context).sessionManager

    private val mediaRouter
        get() = MediaRouter.getInstance(context)

    private val currentRemoteMediaClient
        get() = currentSession.currentCastSession?.remoteMediaClient

    operator fun invoke(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "start_device" -> startDevice(methodCall.arguments as String, result)
            "set_media" -> setMedia(methodCall.arguments as Map<String, Any>, result)
            "seek" -> seek(methodCall.arguments as Int, result)
            "play" -> play(result)
            "pause" -> pause(result)
            "disconnect_device" -> disconnectDevice(result)
            else -> result.notImplemented()
        }
    }

    private fun startDevice(id: String, result: MethodChannel.Result) {
        val routes = mediaRouter.routes
        val selectedRoute = routes.find {
            val device = CastDevice.getFromBundle(it.extras)
            device?.deviceId == id
        }
        if (selectedRoute != null) {
            mediaRouter.selectRoute(selectedRoute)
            result.success(true)
            return
        }
        result.success(false)
    }

    private fun setMedia(data: Map<String, *>, result: MethodChannel.Result) {
        val url = data["url"] as String
        val contentType = data["content_type"] as String? ?: "videos/mp4"
        val isPlaying = data["is_playing"] as Boolean? ?: true
        val playPosition = data["play_position"] as Int? ?: 0

        val builder = MediaInfo.Builder(url)
            .setStreamType(MediaInfo.STREAM_TYPE_BUFFERED)
            .setContentType(contentType)
            .build()
        val builderLoad = MediaLoadOptions.Builder().setAutoplay(isPlaying)
            .setPlayPosition((playPosition * 1000).toLong()).build()
        currentRemoteMediaClient?.load(builder, builderLoad)
        result.success(null)
    }

    private fun play(result: MethodChannel.Result) {
        currentRemoteMediaClient?.play()
        result.success(null)
    }

    private fun pause(result: MethodChannel.Result) {
        currentRemoteMediaClient?.pause()
        result.success(null)
    }

    private fun seek(inSeconds: Int, result: MethodChannel.Result) {
        val mediaSeek = MediaSeekOptions.Builder().setPosition((inSeconds * 1000).toLong()).build()
        currentRemoteMediaClient?.seek(mediaSeek)
        result.success(null)
    }

    private fun disconnectDevice(result: MethodChannel.Result) {
        currentSession.endCurrentSession(true)
        result.success(null)
    }
}