package br.com.ziyou.channels

import android.content.Context
import androidx.mediarouter.media.MediaRouteSelector
import androidx.mediarouter.media.MediaRouter
import com.google.android.gms.cast.CastDevice
import com.google.android.gms.cast.CastMediaControlIntent
import com.google.gson.Gson
import io.flutter.plugin.common.EventChannel

class DiscoveryChromeCastChannel(private val context: Context) : EventChannel.StreamHandler,
    MediaRouter.Callback() {
    private val mediaRouter
        get() = MediaRouter.getInstance(context)

    private val selector = MediaRouteSelector.Builder()
        .addControlCategories(listOf(CastMediaControlIntent.categoryForRemotePlayback()))
        .build()

    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        mediaRouter.addCallback(
            selector, this, MediaRouter.CALLBACK_FLAG_REQUEST_DISCOVERY
        )
    }

    override fun onCancel(arguments: Any?) {
        mediaRouter.removeCallback(this)
        eventSink = null
    }

    override fun onRouteAdded(router: MediaRouter, route: MediaRouter.RouteInfo) {
        super.onRouteAdded(router, route)
        eventSink?.success(getCastDevice())
    }

    override fun onRouteRemoved(router: MediaRouter, route: MediaRouter.RouteInfo) {
        super.onRouteRemoved(router, route)
        eventSink?.success(getCastDevice())
    }

    override fun onRouteChanged(router: MediaRouter, route: MediaRouter.RouteInfo) {
        super.onRouteChanged(router, route)
        eventSink?.success(getCastDevice())
    }

    private fun getCastDevice(): String {
        val devices = mutableListOf<Device>()
        for (route in mediaRouter.routes) {
            val castDevice = CastDevice.getFromBundle(route.extras)
            if (castDevice != null) {
                devices.add(
                    Device(
                        id = castDevice.deviceId,
                        name = castDevice.friendlyName,
                    )
                )
            }
        }
        val data = Gson().toJson(devices)
        return data
    }

}