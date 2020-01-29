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
        return "com.PrivateRouter.PrivateMailFiles.Share"
    }
    
    override func sharedKey()->String{
        return "SharedKey"
    }
    
    override func sharedGroupName() -> String {
        return "group.privatemail.files"
    }

}
