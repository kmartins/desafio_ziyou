package br.com.ziyou

import br.com.ziyou.channels.ChromeCastPlayerChannel
import br.com.ziyou.channels.DiscoveryChromeCastChannel
import br.com.ziyou.channels.SessionChromeCastChannel
import com.google.android.gms.cast.framework.CastContext
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val chromeCastPlayerChannelName = "br.com.ziyou/player_chrome_cast"
    private val sessionChromeCastChannelName = "br.com.ziyou/chrome_cast_session"
    private val discoveryChromeCastChannelName = "br.com.ziyou/discovery_chrome_cast"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        CastContext.getSharedInstance(context)
        val sessionChromeCastChannel = SessionChromeCastChannel(context)
        val chromeCastPlayerChannel = ChromeCastPlayerChannel(context);
        val discoveryChromeCastChannel = DiscoveryChromeCastChannel(context)
        val sessionChromeCastEventChannel = EventChannel(binaryMessenger, sessionChromeCastChannelName)
        val discoveryChromeCastEventChannel = EventChannel(binaryMessenger, discoveryChromeCastChannelName)
        MethodChannel(binaryMessenger, chromeCastPlayerChannelName).setMethodCallHandler {
                call, result -> chromeCastPlayerChannel(call, result)
        }
        sessionChromeCastEventChannel.setStreamHandler(sessionChromeCastChannel)
        discoveryChromeCastEventChannel.setStreamHandler(discoveryChromeCastChannel)
    }

}
