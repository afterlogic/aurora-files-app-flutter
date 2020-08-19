import UIKit
import Flutter
import CommonCrypto
import Foundation
import receive_sharing
import Firebase
import CryptoSwift

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        UserDefaults().set("group.privatemail.files",forKey: SwiftReceiveSharingPlugin.shareGroupKey)
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let encryptionChannel = FlutterMethodChannel(name: "ios_aes_crypt",
                                                     binaryMessenger: controller.binaryMessenger)
        encryptionChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if(self==nil){
                result(FlutterMethodNotImplemented)
                return;
            }
            do{
                var arg = (call.arguments as! [Any]).makeIterator()
                let method=call.method
                let fileData = (arg.next() as! FlutterStandardTypedData).data
                let key = (arg.next() as! String)
                let iv = (arg.next() as! String)
                let isLast = arg.next() as! Bool
                let isDecrypt = method == "decrypt"
                
                result( try self!.aesCrypt(fileData,key,iv,isLast,isDecrypt))
            }catch{
                result(FlutterMethodNotImplemented)
            }
            
        })
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func aesCrypt(_ data:Data,_ key: String,_ iv:String,_ isLast:Bool,_ isDecrypt:Bool) throws->Data {
        let ivData: Array<UInt8> = Array(base64: iv)
        let keyData: Array<UInt8> = Array(base64: key)
        let cbc = CBC(iv: ivData)
        let aes = try AES(key: keyData,blockMode:cbc, padding: isLast ? .pkcs5 : .noPadding) // aes128
        let  ciphertext = isDecrypt ? try aes.decrypt(Array(data)):  try aes.encrypt(Array(data))
   
        return   Data.init(ciphertext)
    }
}
extension String {
    func base64_decode() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
