import UIKit
import Flutter
import CommonCrypto
import Foundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let encryptionChannel = FlutterMethodChannel(name: "PrivateMailFiles.PrivateRouter.com/encryption",
                                              binaryMessenger: controller.binaryMessenger)
    encryptionChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if (call.method == "encrypt") {
            result(self?.performCryption(call: call, isDecrypt: false))
            return
        } else if (call.method == "decrypt") {
            result(self?.performCryption(call: call, isDecrypt: true))
            return
        } else {
            result(FlutterMethodNotImplemented)
            return
        }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func performCryption(call: FlutterMethodCall, isDecrypt: Bool) -> [UInt8] {
        let args = call.arguments as? [Any]
        let fileContent = args?[0] as! FlutterStandardTypedData
        let key = args?[1] as! String
        let iv = args?[2] as! String
        let isLast = args?[3] as! Bool
    
        let encryptedData = crypt(
            data: Data.init(fileContent.data),
            keyData: Data.init(base64Encoded: key)!,
            ivData: Data.init(base64Encoded: iv)!,
            isLast: isLast,
            operation: isDecrypt ? kCCDecrypt : kCCEncrypt
        )
        
        return encryptedData.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: encryptedData.count))
        }
    }
    
    private func crypt(data:Data, keyData:Data, ivData:Data, isLast:Bool, operation:Int) -> Data {
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)
        
        let keyLength = size_t(kCCKeySizeAES256)
        let options = CCOptions(isLast ? kCCOptionPKCS7Padding : ccNoPadding)
        
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes, keyLength,
                                ivBytes,
                                dataBytes, data.count,
                                cryptBytes, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
            
        } else {
            print("Error: \(cryptStatus)")
        }
        
        return cryptData;
    }
}
