//
//  SocialMediaController.swift
//  KRLX
//
//  Created by Naomi Yamamoto on 5/16/15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation
import Social
import UIKit

class SocialMediaController: UIViewController{
    let transitionManager = MenuTransitionManager()
    
    @IBOutlet weak var twitterIcon: UIImageView!
    
    @IBOutlet weak var facebookIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.transitioningDelegate = self.transitionManager
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

