import Flutter
import UIKit
import Foundation
import RxSwift

public class SwiftCryptoPlugin: NSObject, FlutterPlugin {
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    let composite = CompositeDisposable()
    var pgp = Pgp()
    
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

        let disposable =  Single<Any>.create { emitter in
            do {
                let data  = try self.execute(algorithm: algorithm, method:method, arguments: arguments)
                emitter(SingleEvent.success(data))
            } catch let error {
                emitter(SingleEvent.error(error))
            }
            return Disposables.create {}
        }
            .subscribeOn(arguments.isEmpty ? MainScheduler.instance:scheduler)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { (any) in
                result(any)
            },onError: { (error) in
                
                if error is MethodNotImplemented{
                    result(FlutterMethodNotImplemented)
                }else if error is  CryptionError{
                    result( FlutterError(code: "CryptionError", message: (error as! CryptionError).message, details: nil))
                }else{
                    result( FlutterError(code: "error", message:  error.localizedDescription, details: nil))
                }
        })
        composite.insert(disposable)
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
            switch method {
            case "clear":
                self.pgp = Pgp()
                self.composite.dispose()
                return ""
            case "stop":
                self.composite.dispose()
                return ""
            case "getKeyDescription":
                let data = arguments[0] as! String
                return [try self.pgp.getKeyDescription(  data.data(using: String.Encoding.utf8)!),nil]
            case "setPrivateKey":
                let data = arguments[0] as! String
                try self.pgp.setPrivateKey( data.data(using: String.Encoding.utf8)!)
                return ""
            case "setPublicKey":
                let data = arguments[0] as! String
                try self.pgp.setPublicKey(  data.data(using: String.Encoding.utf8)!)
                return ""
            case "decryptBytes":
                let data = arguments[0] as! FlutterStandardTypedData
                let password = arguments[1] as! String
                let result = try self.pgp.decrypt(Data.init(data.data), password)
                return   result.withUnsafeBytes {
                    [UInt8](UnsafeBufferPointer(start: $0, count: result.count))
                }
            case "encryptBytes":
                let data = arguments[0] as! FlutterStandardTypedData
                let result = try self.pgp.encrypt(Data.init(data.data))
                return   result.withUnsafeBytes {
                    [UInt8](UnsafeBufferPointer(start: $0, count: result.count))
                }
            default:
                break
            }
            break
        default:
            break
        }
        
        throw MethodNotImplemented()
    }
}

class CryptionError :Error{
    let message:String
    
    init(_ message:String="") {
        self.message=message
    }
}

class MethodNotImplemented :Error{}
