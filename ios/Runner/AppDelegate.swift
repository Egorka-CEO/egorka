import UIKit
import Flutter
import GoogleMaps
import Firebase
import YandexMapsMobile

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    YMKMapKit.setApiKey("d56975e0-35ed-4be0-84c9-2766e15664e4")
    // GMSServices.provideAPIKey("AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
                Messaging.messaging().apnsToken = deviceToken
                super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
            
        override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
                Messaging.messaging().appDidReceiveMessage(userInfo)
        }
}
