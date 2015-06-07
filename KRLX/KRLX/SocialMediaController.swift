//
//  SocialMediaController.swift
//  KRLX
//
//  Created by Naomi Yamamoto on 5/16/15.
//  Reference: http://mathewsanders.com/custom-menu-transitions-in-swift/
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation
import Social
import UIKit

class SocialMediaController: UIViewController{
    
    @IBOutlet weak var menuBarItem: UINavigationItem!
    
    let transitionManager = MenuTransitionManager()
        
    var articleURL: String = "Article URL\n"
    
    @IBOutlet weak var facebookIcon: UIButton!
    
    
    @IBOutlet weak var twitterIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.transitioningDelegate = self.transitionManager
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goBackToArticlePage(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func twitterButtonSender(sender: AnyObject) {
       
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.addURL(NSURL(string: articleURL))
            self.presentViewController(tweetShare, animated: true, completion: nil)

    }
    
   
    @IBAction func facebookButtonSender(sender: AnyObject) {

            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.addURL(NSURL(string: articleURL))
            self.presentViewController(fbShare, animated: true, completion: nil)

    }

}

