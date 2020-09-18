import UIKit
import Flutter
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
    
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
}
