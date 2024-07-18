package twilio.flutter.conversations_example

import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback

class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
    }

    // These plugins are registered here to allow for background messages to be received
    // and notifications to be displayed outside of the lifecycle of the MainActivity
    override fun registerWith(registry: PluginRegistry) {
        FlutterLocalNotificationsPlugin.registerWith(registry?.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
    }
}
