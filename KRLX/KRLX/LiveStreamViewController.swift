//
//  LiveStreamViewController.swift
//  KRLX
//
//  Created by KRLXxpert on 07/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class LiveStreamViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIButton!
    
    var isPlaying = true
    // http://stackoverflow.com/questions/5655864/check-play-state-of-avplayer

    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonPressed(sender: AnyObject) {
        if isPlaying {
            playRadio()
            isPlaying = false
        }else{
            pauseRadio()
            isPlaying = true
            
        }
    }
    
    func playRadio() {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.player.play()
        let image = UIImage(named: "pause") as UIImage?
        playButton.setBackgroundImage(image, forState: UIControlState.Normal)
    }
    
    func pauseRadio() {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.player.pause()
        let image = UIImage(named: "play") as UIImage?
        playButton.setBackgroundImage(image, forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
}
