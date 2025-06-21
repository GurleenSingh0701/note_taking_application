<<<<<<< HEAD
import UIKit
import Flutter

@UIApplicationMain
=======
import Flutter
import UIKit

@main
>>>>>>> 50b6fc1 (this is the first commit added the welcome and onboarding screen and added the google login system using firebase)
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
