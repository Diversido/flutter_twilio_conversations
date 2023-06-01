package twilio.flutter.twilio_conversations

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.twilio.conversations.ConversationsClient
import com.twilio.util.ErrorInfo
import com.twilio.conversations.StatusListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar
import twilio.flutter.twilio_conversations.listeners.ChannelListener
import twilio.flutter.twilio_conversations.listeners.ChatListener

/** TwilioConversationsPlugin */
class TwilioConversationsPlugin : FlutterPlugin {
    private lateinit var methodChannel: MethodChannel

    private lateinit var chatChannel: EventChannel

    private lateinit var mediaProgressChannel: EventChannel

    private lateinit var loggingChannel: EventChannel

    private lateinit var notificationChannel: EventChannel

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @Suppress("unused")
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            instance = TwilioConversationsPlugin()
            instance.onAttachedToEngine(registrar.context(), registrar.messenger())
        }

        lateinit var messenger: BinaryMessenger

        @JvmStatic
        lateinit var instance: TwilioConversationsPlugin

        var chatClient: ConversationsClient? = null

        val LOG_TAG = "Twilio_PChat"

        var mediaProgressSink: EventChannel.EventSink? = null

        var loggingSink: EventChannel.EventSink? = null

        var notificationSink: EventChannel.EventSink? = null

        var handler = Handler(Looper.getMainLooper())

        var nativeDebug: Boolean = false

        lateinit var chatListener: ChatListener

        var channelChannels: HashMap<String, EventChannel> = hashMapOf()
        var channelListeners: HashMap<String, ChannelListener> = hashMapOf()

        @JvmStatic
        fun debug(msg: String) {
            if (nativeDebug) {
                Log.d(LOG_TAG, msg)
                handler.post(Runnable {
                    loggingSink?.success(msg)
                })
            }
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        instance = this
        onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
    }

    private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
        TwilioConversationsPlugin.messenger = messenger
        val pluginHandler = PluginHandler(applicationContext)
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

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        debug("TwilioConversationsPlugin.onDetachedFromEngine")
        methodChannel.setMethodCallHandler(null)
        chatChannel.setStreamHandler(null)
        loggingChannel.setStreamHandler(null)
        notificationChannel.setStreamHandler(null)
        mediaProgressChannel.setStreamHandler(null)
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

    private fun sendNotificationEvent(name: String, data: Any?, e: ErrorInfo? = null) {
        val eventData = mapOf("name" to name, "data" to data, "error" to Mapper.errorInfoToMap(e))
        notificationSink?.success(eventData)
    }
}
