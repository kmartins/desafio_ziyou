package br.com.ziyou.channels

import android.content.Context
import com.google.android.gms.cast.framework.CastContext
import com.google.android.gms.cast.framework.Session
import com.google.android.gms.cast.framework.SessionManagerListener
import io.flutter.plugin.common.EventChannel

class SessionChromeCastChannel(private val context: Context) : EventChannel.StreamHandler,
    SessionManagerListener<Session> {
    private var eventSink: EventChannel.EventSink? = null

    private val currentSession
        get() = CastContext.getSharedInstance(context).sessionManager

    override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
        currentSession.addSessionManagerListener(this)
    }

    override fun onCancel(arguments: Any?) {
        currentSession.removeSessionManagerListener(this)
        eventSink = null
    }

    override fun onSessionEnded(p0: Session, p1: Int) {
        sendChromeCastState()
    }

    override fun onSessionEnding(p0: Session) {
        sendChromeCastState()
    }

    override fun onSessionResumeFailed(p0: Session, p1: Int) {
        sendChromeCastState()
    }

    override fun onSessionResumed(p0: Session, p1: Boolean) {
        sendChromeCastState()
    }

    override fun onSessionResuming(p0: Session, p1: String) {
        sendChromeCastState()
    }

    override fun onSessionStartFailed(p0: Session, p1: Int) {
        sendChromeCastState()
    }

    override fun onSessionStarted(p0: Session, p1: String) {
        sendChromeCastState()
    }

    override fun onSessionStarting(p0: Session) {
        sendChromeCastState()
    }

    override fun onSessionSuspended(p0: Session, p1: Int) {
        sendChromeCastState()
    }

    private fun sendChromeCastState() {
        val session = currentSession.currentCastSession
        val state = when (true) {
            session?.isDisconnecting -> "disconnecting"
            session?.isConnected -> "connected"
            session?.isConnecting -> "connecting"
            else -> "disconnected"
        }
        eventSink?.success(state)
    }
}