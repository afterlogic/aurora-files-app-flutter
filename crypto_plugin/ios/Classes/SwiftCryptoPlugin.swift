import Flutter
import UIKit
import Foundation

public class SwiftCryptoPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "crypto_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftCryptoPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let route = call.method.components(separatedBy: ".")
        let algorithm = route[0]
        let method = route[1]
        let arguments = call.arguments as! [Any]
        print(algorithm + "." + method)
        do {
           result(try execute(algorithm: algorithm, method:method, arguments: arguments))
        } catch let error {
             result(FlutterMethodNotImplemented)
        }
    }

    private func execute(algorithm: String, method: String, arguments: [Any]) throws -> Any {
        switch algorithm {
        case "aes":
            let fileContent = arguments[0] as! FlutterStandardTypedData
            let key = arguments[1] as! String
            let iv = arguments[2] as! String
            let isLast = arguments[3] as! Bool
            let isDecrypt = method == "decrypt"
            let encryptedData = Aes.performCryption(
                     Data.init(fileContent.data),
                     Data.init(base64Encoded: key)!,
                     Data.init(base64Encoded: iv)!,
                     isLast,
                     isDecrypt
            )
            return encryptedData.withUnsafeBytes {
                [UInt8](UnsafeBufferPointer(start: $0, count: encryptedData.count))
            
        }
        case "pgp":
            break
        default:
            break
        }
        
      throw CustomError()
    }
}

class CustomError :Error{
    
}
