package twilio.flutter.twilio_conversations

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.twilio.conversations.ConversationsClient
import com.twilio.util.ErrorInfo
import com.twilio.conversations.StatusListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import twilio.flutter.twilio_conversations.listeners.ChannelListener
import twilio.flutter.twilio_conversations.listeners.ChatListener

/** TwilioConversationsPlugin */
class TwilioConversationsPlugin : FlutterPlugin {
    companion object {
        const val LOG_TAG = "Twilio_PChat"

        // One Twilio conversation client and each Flutter engine will have it's own listener
        var chatClient: ConversationsClient? = null
        var chatClientRegion: String? = null
        var chatClientDeferCA: Boolean? = null
    }

    private lateinit var methodChannel: MethodChannel

    private lateinit var chatChannel: EventChannel

    private lateinit var mediaProgressChannel: EventChannel

    private lateinit var loggingChannel: EventChannel

    private lateinit var notificationChannel: EventChannel

    lateinit var messenger: BinaryMessenger

    lateinit var chatListener: ChatListener

    var mediaProgressSink: EventChannel.EventSink? = null

    var loggingSink: EventChannel.EventSink? = null

    var notificationSink: EventChannel.EventSink? = null

    var handler = Handler(Looper.getMainLooper())

    var channelChannels: HashMap<String, EventChannel> = hashMapOf()
    var channelListeners: HashMap<String, ChannelListener> = hashMapOf()

    var nativeDebug: Boolean = false

    fun debug(msg: String) {
        if (nativeDebug) {
            Log.d(LOG_TAG, msg)
            handler.post {
                loggingSink?.success(msg)
            }
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, binaryMessenger: BinaryMessenger) {
        messenger = binaryMessenger

        val pluginHandler = PluginHandler(this, applicationContext)
        methodChannel = MethodChannel(messenger, "flutter_twilio_conversations")
        methodChannel.setMethodCallHandler(pluginHandler)

        chatChannel = EventChannel(messenger, "flutter_twilio_conversations/room")
        chatChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioConversationsPlugin.onAttachedToEngine => Chat eventChannel attached")
                chatListener.events = events
                chatClient?.addListener(chatListener)
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioConversationsPlugin.onAttachedToEngine => Chat eventChannel detached")
                chatListener.events = null
            }
        })

        mediaProgressChannel = EventChannel(messenger, "flutter_twilio_conversations/media_progress")
        mediaProgressChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioConversationsPlugin.onAttachedToEngine => MediaProgress eventChannel attached")
                mediaProgressSink = events
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioConversationsPlugin.onAttachedToEngine => MediaProgress eventChannel detached")
                mediaProgressSink = null
            }
        })

        loggingChannel = EventChannel(messenger, "flutter_twilio_conversations/logging")
        loggingChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioConversationsPlugin.onAttachedToEngine => Logging eventChannel attached")
                loggingSink = events
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioConversationsPlugin.onAttachedToEngine => Logging eventChannel detached")
                loggingSink = null
            }
        })

        notificationChannel = EventChannel(messenger, "flutter_twilio_conversations/notification")
        notificationChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                debug("TwilioConversationsPlugin.onAttachedToEngine => Notification eventChannel attached")
                notificationSink = events
            }

            override fun onCancel(arguments: Any?) {
                debug("TwilioConversationsPlugin.onAttachedToEngine => Notification eventChannel detached")
                notificationSink = null
            }
        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        debug("TwilioConversationsPlugin.onDetachedFromEngine")
        methodChannel.setMethodCallHandler(null)
        chatChannel.setStreamHandler(null)
        loggingChannel.setStreamHandler(null)
        notificationChannel.setStreamHandler(null)
        mediaProgressChannel.setStreamHandler(null)
        channelChannels.clear()
        channelListeners.clear()
    }

    fun registerForNotification(call: MethodCall, result: MethodChannel.Result) {
        val token: String = call.argument<String>("token")
                ?: return result.error("MISSING_PARAMS", "The parameter 'token' was not given", null)

        chatClient?.registerFCMToken(ConversationsClient.FCMToken(token), object : StatusListener {
            override fun onSuccess() {
                try {
                    debug("TwilioConversationsPlugin.registerForNotification => registered with FCM $token")
                    sendNotificationEvent("registered", mapOf("result" to true))
                    result.success("Succeeded in Android")
                } catch (e: Exception) {
                    debug("TwilioConversationsPlugin.registerForNotification => failed to register with FCM")
                }
            }

            override fun onError(errorInfo: ErrorInfo?) {
                try {
                    debug("TwilioConversationsPlugin.registerForNotification => failed to register with FCM")
                    super.onError(errorInfo)
                    sendNotificationEvent("registered", mapOf("result" to false), errorInfo)
                    result.error("FAILED", "Failed to register for FCM notifications", errorInfo)
                } catch (e: Exception) {
                    debug("TwilioConversationsPlugin.registerForNotification => failed to register with FCM")
                }
            }
        })
    }

    fun unregisterForNotification(call: MethodCall, result: MethodChannel.Result) {
        val token: String = call.argument<String>("token")
                ?: return result.error("MISSING_PARAMS", "The parameter 'token' was not given", null)

        chatClient?.unregisterFCMToken(ConversationsClient.FCMToken(token), object : StatusListener {
            override fun onSuccess() {
                try {
                    debug("TwilioConversationsPlugin.unregisterForNotification => unregistered with FCM $token")
                    sendNotificationEvent("deregistered", mapOf("result" to true))
                    result.success(null)
                } catch (e: Exception) {
                    debug("TwilioConversationsPlugin.unregisterForNotification => failed to unregister with FCM")
                }
            }

            override fun onError(errorInfo: ErrorInfo?) {
                try {
                    debug("TwilioConversationsPlugin.unregisterForNotification => failed to unregister with FCM")
                    super.onError(errorInfo)
                    sendNotificationEvent("deregistered", mapOf("result" to false), errorInfo)
                    result.error("FAILED", "Failed to unregister for FCM notifications", errorInfo)
                } catch (e: Exception) {
                    debug("TwilioConversationsPlugin.unregisterForNotification => failed to unregister with FCM")
                }
            }
        })
    }

    // This is a no-op for a method needed on iOS
    fun handleReceivedNotification(call: MethodCall, result: MethodChannel.Result) {
        result.success(null)
    }

    private fun sendNotificationEvent(name: String, data: Any?, e: ErrorInfo? = null) {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        notificationSink?.success(eventData)
    }
}
