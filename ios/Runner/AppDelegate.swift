import UIKit
import Flutter
import CommonCrypto
import Foundation
import receive_sharing
import Firebase
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    UserDefaults().set("group.privatemail.files",forKey: SwiftReceiveSharingPlugin.shareGroupKey)
    
    CryptoPlugin.register(with: self.registrar(forPlugin: "crypto_plugin"))
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

}
