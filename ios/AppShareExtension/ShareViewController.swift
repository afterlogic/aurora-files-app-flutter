//
//  ShareViewController.swift
//  AppShareExtension
//
//  Created by Alexander Orlov on 28.01.2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
import Social
import receive_sharing

class ShareViewController: SharingHelper {
    
    override func shareUrl()->String{
        let value = Bundle.main.object(forInfoDictionaryKey:"MAIN_APP_ID")
        return (value as! String)+".Share"
    }
    
    override func sharedGroupName() -> String {
        return "group.privatemail.files"
    }

}
