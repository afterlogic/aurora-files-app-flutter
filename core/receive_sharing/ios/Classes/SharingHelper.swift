//
//  SharingHelper.swift
//  receive_sharing
//
//  Created by Alexander Orlov on 28.01.2020.
//

import Foundation
import UIKit
import Social
import MobileCoreServices
import Photos

open class SharingHelper : SLComposeServiceViewController {
    
    open func shareUrl()->String{
        return ""
    }
    
    open func sharedKey()->String{
        return ""
    }
    
    open func sharedGroupName() -> String {
        return ""
    }
    
    override open func isContentValid() -> Bool {
        return true
    }
    
    override open func viewDidLoad() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        extensionContext?.inputItems.forEach({ (item) in
            item
        })
        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            if content.attachments != nil{
                handleAttachment(content: content, attachment: content.attachments!, onComplete:{
                    self.dismiss(animated: false, completion: nil)
                })
                return
            }
        }
        
        self.dismiss(animated: false, completion: nil)
    }
    
    override open func didSelectPost() {
        print("didSelectPost");
    }
    
    override open func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    private func handleAttachment (content: NSExtensionItem, attachment: [NSItemProvider], onComplete: @escaping ()->Void) {
        var sharedMedia: [SharedMediaFile] = []
        var index = 0
        let count = attachment.count
     
        if count == index {
            onComplete()
        }
        attachment.forEach({ (attachmentItem) in
            let type = attachmentItem.registeredTypeIdentifiers.first
            if(type==nil){
                index += 1
                if index == count {
                    onComplete()
                }
                return
            }
            attachmentItem.loadItem(forTypeIdentifier: type!, options: nil) { [weak self] data, error in
                if error == nil && data != nil {
                    let item = self?.convertAttachment(data: data!,type: type!)
                    if item != nil {
                        sharedMedia.append(item!)
                    }
                }
                index += 1
                if index == count {
                    if !sharedMedia.isEmpty, let this = self {
                        let userDefaults = UserDefaults(suiteName: this.sharedGroupName())
                        userDefaults?.set(this.toData(data: sharedMedia), forKey: this.sharedKey())
                        userDefaults?.synchronize()
                        this.redirectToHostApp()
                    }
                    onComplete()
                }
            }
        })
    }
    
    func convertAttachment(data:NSSecureCoding,type:String)->SharedMediaFile?{
        let typeUrl=kUTTypeURL as String
        let typeText=kUTTypeText as String
        
        switch type {
        case typeUrl:
            if let item = data as? URL {
                return SharedMediaFile.init(name: type,
                                            path: nil,
                                            text: item.absoluteString,
                                            type: SharedMediaType.text)
            }
            break
        case typeText:
            if let item = data as? String {
                return SharedMediaFile.init(name: type,
                                            path: nil,
                                            text: item,
                                            type: SharedMediaType.text)
            }
            break
        default:
            if let url = data as? URL {
                let fileName = url.lastPathComponent
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: self.sharedGroupName())!
                    .appendingPathComponent(fileName)
                let copied = self.copyFile(at: url, to: newPath)
                if(copied){
                    return SharedMediaFile.init(name: fileName,
                                                path: newPath.absoluteString,
                                                text: nil,
                                                type: SharedMediaType.media)
                }
            }
        }
        
        return nil
    }
    
    private func dismissWithError() {
        print("GETTING ERROR")
        let alert = UIAlertController(title: "Error", message: "Error loading data", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private func redirectToHostApp() {
        let url = URL(string: "\(shareUrl())://dataUrl=\(sharedKey())")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
    }

    func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }
    
    func toData(data: [SharedMediaFile]) -> Data {
        let encodedData = try? JSONEncoder().encode(data)
        return encodedData!
    }
}

extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
