//
//  ShareViewController.swift
//  socialMediaSharing
//
//  Created by Naomi Yamamoto on 6/6/15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//
//  Instruction obtained from https://www.shinobicontrols.com/blog/posts/2014/07/21/ios8-day-by-day-day-2-sharing-extension

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
