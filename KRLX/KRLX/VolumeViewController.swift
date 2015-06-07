//
//  VolumeViewController.swift
//  KRLX
//
//  Created by Naomi Yamamoto on 5/30/15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation
class VolumeViewController: UIViewController {
     var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var volumeSlider: UISlider!{
        didSet{
        volumeSlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        }
    }
    

    override func viewDidLoad() {
        volumeSlider.value = appDelegate.currentVolume

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func changeVolume(sender: UISlider) {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.currentVolume = Float(sender.value)
        appDelegate.player.volume = appDelegate.currentVolume
        
    }
    
    
    
}