import Flutter
import UIKit
import Photos

public class SwiftReceiveSharingPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    public static let shareGroupKey = "ShareGroup";
    static let kMessagesChannel = "receive_sharing/messages";
    static let kEventsChannelMedia = "receive_sharing/events-media";
    
    private var latestMedia: [SharedMediaFile]? = nil
    
    private var eventSinkMedia: FlutterEventSink? = nil;
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftReceiveSharingPlugin()
        
        let channel = FlutterMethodChannel(name: kMessagesChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let chargingChannelMedia = FlutterEventChannel(name: kEventsChannelMedia, binaryMessenger: registrar.messenger())
        chargingChannelMedia.setStreamHandler(instance)
        
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
        case "getInitialMedia":
            result(toJson(data: self.latestMedia));
        case "reset":
            self.latestMedia = nil
            result(nil);
        default:
            result(FlutterMethodNotImplemented);
        }
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        if let url = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL {
            return handleUrl(url: url, setInitialData: true)
        } else if let activityDictionary = launchOptions[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] { //Universal link
            for key in activityDictionary.keys {
                if let userActivity = activityDictionary[key] as? NSUserActivity {
                    if let url = userActivity.webpageURL {
                        return handleUrl(url: url, setInitialData: true)
                    }
                }
            }
        }
        return false
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return handleUrl(url: url, setInitialData: false)
    }
    
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        return handleUrl(url: userActivity.webpageURL, setInitialData: true)
    }
    
    private func handleUrl(url: URL?, setInitialData: Bool) -> Bool {
        if let url = url {
            let shareGroup = UserDefaults().string(forKey: SwiftReceiveSharingPlugin.shareGroupKey)
            let userDefaults = UserDefaults(suiteName:shareGroup)
 
            if let key = url.host?.components(separatedBy: "=").last,
                let json = userDefaults?.object(forKey: key) as? Data {
                let sharedArray = decode(data: json)
                let sharedMediaFiles: [SharedMediaFile] = sharedArray.compactMap{ (sharedFile) in
                    var path :String?
                    if(sharedFile.path != nil){
                        path = getAbsolutePath(for: sharedFile.path!)
                    }
                    return SharedMediaFile.init(name: sharedFile.name, path: path, text: sharedFile.text, type:sharedFile.type)
                }
                latestMedia = sharedMediaFiles
                if !sharedMediaFiles.isEmpty {
                    eventSinkMedia?(toJson(data: latestMedia))
                }
            }
          
            return true
        }
        
        latestMedia = nil
        return false
    }
    
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if (arguments as! String? == "media") {
            eventSinkMedia = events;
        }  else {
            return FlutterError.init(code: "NO_SUCH_ARGUMENT", message: "No such argument\(String(describing: arguments))", details: nil);
        }
        return nil;
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        if (arguments as! String? == "media") {
            eventSinkMedia = nil;
        } else {
            return FlutterError.init(code: "NO_SUCH_ARGUMENT", message: "No such argument as \(String(describing: arguments))", details: nil);
        }
        return nil;
    }
    
    private func getAbsolutePath(for identifier: String) -> String? {
        if (identifier.starts(with: "file://") || identifier.starts(with: "/var/mobile/Media") || identifier.starts(with: "/private/var/mobile")) {
            return identifier.replacingOccurrences(of: "file://", with: "")
        }
        let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: .none).firstObject
        if(phAsset == nil) {
            return nil
        }
        return  getFullSizeImageURLAndOrientation(for: phAsset!)
    }
    
    private func getFullSizeImageURLAndOrientation(for asset: PHAsset)->String?{
        var url: String? = nil

        let semaphore = DispatchSemaphore(value: 0)
        let options2 = PHContentEditingInputRequestOptions()
        options2.isNetworkAccessAllowed = true
        asset.requestContentEditingInput(with: options2){(input, info) in
            url = input?.fullSizeImageURL?.path
            semaphore.signal()
        }
        semaphore.wait()
        
        return url
    }
    
    private func decode(data: Data) -> [SharedMediaFile] {
        let encodedData = try? JSONDecoder().decode([SharedMediaFile].self, from: data)
        return encodedData!
    }
    
    private func toJson(data: [SharedMediaFile]?) -> String? {
        if data == nil {
            return nil
        }
        let encodedData = try? JSONEncoder().encode(data)
        let json = String(data: encodedData!, encoding: .utf8)!
        return json
    }
}

class SharedMediaFile: Codable {
    var name:String
    var path: String?
    var text: String?
    var type: SharedMediaType
    
    
    init(name: String, path: String?, text: String?, type: SharedMediaType) {
        self.name = name
        self.path = path
        self.text = text
        self.type = type
    }
}

enum SharedMediaType: Int, Codable {
    case media
    case text
    case any
}
