import Flutter
import UIKit
import TwilioConversationsClient

public class SwiftTwilioConversationsPlugin: NSObject, FlutterPlugin {
    public static var loggingSink: FlutterEventSink?

    public static var notificationSink: FlutterEventSink?

    public static var nativeDebug = false

    public static var messenger: FlutterBinaryMessenger?

    public static var chatListener: ChatListener?

    public static var channelChannels: [String: FlutterEventChannel] = [:]

    public static var channelListeners: [String: ChannelListener] = [:]

    public static var mediaProgressSink: FlutterEventSink?

    public static var reasonForTokenRetrieval: String?

    public static var instance: SwiftTwilioConversationsPlugin?
    
    var receivedNotification: [AnyHashable: Any]?

    var globalToken: Data?

    public static func debug(_ msg: String) {
        print("Twilio-iOS \(msg)")
        if SwiftTwilioConversationsPlugin.nativeDebug {
            NSLog(msg)
            guard let loggingSink = loggingSink else {
                return
            }
            loggingSink(msg)
        }
    }

    private var methodChannel: FlutterMethodChannel?

    private var chatChannel: FlutterEventChannel?

    private var mediaProgressChannel: FlutterEventChannel?

    private var loggingChannel: FlutterEventChannel?

    private var notificationChannel: FlutterEventChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        instance = SwiftTwilioConversationsPlugin()
        instance?.onRegister(registrar)
    }

    public func onRegister(_ registrar: FlutterPluginRegistrar) {
        SwiftTwilioConversationsPlugin.messenger = registrar.messenger()
        let pluginHandler = PluginHandler()
        methodChannel = FlutterMethodChannel(name: "flutter_twilio_conversations", binaryMessenger: registrar.messenger())
        methodChannel?.setMethodCallHandler(pluginHandler.handle)

        chatChannel = FlutterEventChannel(name: "flutter_twilio_conversations/room", binaryMessenger: registrar.messenger())
        chatChannel?.setStreamHandler(ChatStreamHandler())

        mediaProgressChannel = FlutterEventChannel(
            name: "flutter_twilio_conversations/media_progress", binaryMessenger: registrar.messenger())
        mediaProgressChannel?.setStreamHandler(MediaProgressStreamHandler())

        loggingChannel = FlutterEventChannel(
            name: "flutter_twilio_conversations/logging", binaryMessenger: registrar.messenger())
        loggingChannel?.setStreamHandler(LoggingStreamHandler())

        notificationChannel = FlutterEventChannel(
            name: "flutter_twilio_conversations/notification", binaryMessenger: registrar.messenger())
        notificationChannel?.setStreamHandler(NotificationStreamHandler())

        registrar.addApplicationDelegate(self)
    }

    public func registerForNotification(_ call: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?],
            let deviceToken = arguments["token"] as? String else {
                return flutterResult(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted: Bool, _: Error?) in
                SwiftTwilioConversationsPlugin.debug("User responded to permissions request: \(granted)")
                if granted {
                    do {
                        DispatchQueue.main.async {
                            SwiftTwilioConversationsPlugin.debug("Requesting APNS token")
                            SwiftTwilioConversationsPlugin.reasonForTokenRetrieval = "register"
                            let dataToken = Data(deviceToken.utf8)
                            let stringToken = String(decoding: dataToken, as: UTF8.self)
                            // length must be 32 bytes but gives 64
                            UIApplication.shared.registerForRemoteNotifications()
                            SwiftTwilioConversationsPlugin.chatListener?.chatClient?.register(withNotificationToken: self.globalToken ?? dataToken, completion: { (result: TCHResult) in
                                SwiftTwilioConversationsPlugin.debug("registered for notifications: \(result.isSuccessful) for stringToken: \(stringToken) and global: \(String(describing: self.globalToken?.description))")
                                SwiftTwilioConversationsPlugin.sendNotificationEvent("registered", data: ["result": result.isSuccessful], error: result.error)
                                flutterResult("Registered for notifications: \(result.isSuccessful) for stringToken: \(stringToken) and global: \(String(describing: self.globalToken?.description))")
                            })
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                } else {
                    flutterResult("No access granted for Twilio Pushes")
                }
            }
        }
    }

    public func unregisterForNotification(_ call: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        if #available(iOS 10.0, *) {
            do {
                DispatchQueue.main.async {
                    SwiftTwilioConversationsPlugin.debug("Requesting APNS token")
                    SwiftTwilioConversationsPlugin.reasonForTokenRetrieval = "deregister"
                    UIApplication.shared.registerForRemoteNotifications()
                    if (self.globalToken != nil) {
                        SwiftTwilioConversationsPlugin.chatListener?.chatClient?.deregister(withNotificationToken: self.globalToken!, completion: { (result: TCHResult) in
                                SwiftTwilioConversationsPlugin.debug("deregistered for notifications: \(result.isSuccessful) for global: \(String(describing: self.globalToken?.description))")
                                SwiftTwilioConversationsPlugin.sendNotificationEvent("deregistered", data: ["result": result.isSuccessful], error: result.error)
                                flutterResult("Deregistered for notifications: \(result.isSuccessful) for global: \(String(describing: self.globalToken?.description))")
                            })
                    }
                }
            } catch let error {
                        print(error.localizedDescription)
                    }
        }
        flutterResult(nil)
    }

    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        globalToken = deviceToken
        SwiftTwilioConversationsPlugin.debug("didRegisterForRemoteNotificationsWithDeviceToken => onSuccess: \((deviceToken as NSData).description)")
        if let reason = SwiftTwilioConversationsPlugin.reasonForTokenRetrieval {
            if reason == "register" {
                SwiftTwilioConversationsPlugin.chatListener?.chatClient?.register(withNotificationToken: deviceToken, completion: { (result: TCHResult) in
                    SwiftTwilioConversationsPlugin.debug("registered for notifications: \(result.isSuccessful)")
                    SwiftTwilioConversationsPlugin.sendNotificationEvent("registered", data: ["result": result.isSuccessful], error: result.error)
                })
            } else {
                SwiftTwilioConversationsPlugin.chatListener?.chatClient?.deregister(withNotificationToken: deviceToken, completion: { (result: TCHResult) in
                    SwiftTwilioConversationsPlugin.debug("deregistered for notifications: \(result.isSuccessful)")
                    SwiftTwilioConversationsPlugin.sendNotificationEvent("deregistered", data: ["result": result.isSuccessful], error: result.error)
                })
            }
        }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                 didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void) {
        SwiftTwilioConversationsPlugin.debug("Received Twilio notification")
        let userInfo = response.notification.request.content.userInfo
        if userInfo != nil {
        if SwiftTwilioConversationsPlugin.chatListener?.chatClient != nil {
            // If your reference to the Conversations client exists 
            // and is initialized, send the notification to it
            SwiftTwilioConversationsPlugin.chatListener?.chatClient?.handleNotification(userInfo) { (result) in
            SwiftTwilioConversationsPlugin.debug("Handling Twilio notification: \(userInfo)")
                if !result.isSuccessful {
                    // Handling of notification was not successful, retry?
                    SwiftTwilioConversationsPlugin.debug("Failed to handle Twilio notification")
                } else {
                    SwiftTwilioConversationsPlugin.debug("Succeeded to handle Twilio notification: \(userInfo)")
                }
            }
        } else {
            // Store the notification for later handling
            receivedNotification = userInfo
        }
        }
    }

    public func application(_ application: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError
        error: Error) {
        SwiftTwilioConversationsPlugin.debug("didFailToRegisterForRemoteNotificationsWithError => onFail")
        SwiftTwilioConversationsPlugin.sendNotificationEvent("registered", data: ["result": false], error: error)
    }

    public static func sendNotificationEvent(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]

        if let notificationSink = SwiftTwilioConversationsPlugin.notificationSink {
            notificationSink(eventData)
        }
    }

    class ChatStreamHandler: NSObject, FlutterStreamHandler {
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            guard let chatListener = SwiftTwilioConversationsPlugin.chatListener else { return nil }
            SwiftTwilioConversationsPlugin.debug("ChatStreamHandler.onListen => Chat eventChannel attached")
            chatListener.events = events
            chatListener.chatClient?.delegate = chatListener
            return nil
        }

        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            SwiftTwilioConversationsPlugin.debug("RoomStreamHandler.onCancel => Room eventChannel detached")
            guard let chatListener = SwiftTwilioConversationsPlugin.chatListener else { return nil }
            chatListener.events = nil
            return nil
        }
    }

    class MediaProgressStreamHandler: NSObject, FlutterStreamHandler {
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            debug("MediaProgressStreamHandler.onListen => MediaProgress eventChannel attached")
            SwiftTwilioConversationsPlugin.mediaProgressSink = events
            return nil
        }

        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            debug("MediaProgressStreamHandler.onCancel => MediaProgress eventChannel detached")
            SwiftTwilioConversationsPlugin.mediaProgressSink = nil
            return nil
        }
    }

    class LoggingStreamHandler: NSObject, FlutterStreamHandler {
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            SwiftTwilioConversationsPlugin.debug("LoggingStreamHandler.onListen => Logging eventChannel attached")
            SwiftTwilioConversationsPlugin.loggingSink = events
            return nil
        }

        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            SwiftTwilioConversationsPlugin.debug("LoggingStreamHandler.onCancel => Logging eventChannel detached")
            SwiftTwilioConversationsPlugin.loggingSink = nil
            return nil
        }
    }

    class NotificationStreamHandler: NSObject, FlutterStreamHandler {
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            SwiftTwilioConversationsPlugin.debug("NotificationStreamHandler.onListen => Notification eventChannel attached")
            SwiftTwilioConversationsPlugin.notificationSink = events
            return nil
        }

        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            SwiftTwilioConversationsPlugin.debug("NotificationStreamHandler.onCancel => Notification eventChannel detached")
            SwiftTwilioConversationsPlugin.notificationSink = nil
            return nil
        }
    }
}
