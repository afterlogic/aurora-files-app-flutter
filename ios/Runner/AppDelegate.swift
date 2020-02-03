import UIKit
import Flutter
import CommonCrypto
import Foundation
import receive_sharing

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {

    UserDefaults().set("group.privatemail.files",forKey: SwiftReceiveSharingPlugin.shareGroupKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

}
