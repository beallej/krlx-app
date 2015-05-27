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
    
    // http://stackoverflow.com/questions/5655864/check-play-state-of-avplayer
    
    @IBOutlet weak var currentShowLabel: UILabel!
    
    @IBOutlet weak var volumeController: UISlider!
    
    var refreshTimer : NSTimer!
    
    
    
    var show_arrays = [ShowHeader]()
    var currentShowName: String = "show"
    var currentDJName: String = "DJ"
    
    override func viewDidLoad() {
        self.currentShowLabel.text = "Loading Show Name and DJ Name..."
        self.setCurrentShow()
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isPlaying {
            let image = UIImage(named: "pause") as UIImage?
            playButton.setBackgroundImage(image, forState: UIControlState.Normal)
            
        }else{
            let image = UIImage(named: "play") as UIImage?
            playButton.setBackgroundImage(image, forState: UIControlState.Normal)
        }
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.setUpTimer()
                // Do any additional setup after loading the view.
    }
    
    
   
    
    func setUpTimer(){
        //refreshes at next half hour
        let timeInt = self.getTimeToRefresh()
        let timeSeconds : NSTimeInterval = Double(timeInt)*60.0
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(timeSeconds, target: self, selector: Selector("refreshShow"), userInfo: nil, repeats: false)
    }
    
    
    func getTimeToRefresh() -> Int{
        let now = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm"
        var minString = dateFormatter.stringFromDate(now) as String
        let minInt = minString.toInt()!
        
        
        var timeToRefresh : Int
        if minInt <= 30 {
            timeToRefresh = 30 - minInt
        }
        else{
            timeToRefresh = 60 - minInt
        }
        return timeToRefresh
        
        
    }
    func refreshShow(){
        self.setCurrentShow()
        //refreshes every 30 minutes
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1800.00, target: self, selector: Selector("setCurrentShow"), userInfo: nil, repeats: true)
        
    }

    
    @IBAction func buttonPressed(sender: AnyObject) {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isPlaying {
            pauseRadio()
            appDelegate.isPlaying = false
        }else{
            playRadio()
            appDelegate.isPlaying = true
            
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
    
    
    @IBAction func changeVolume(sender: UISlider) {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var currentVolume = Float(sender.value)
        appDelegate.player.volume = currentVolume
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentShow(){
        let calendarAssistant = GoogleAPIPull()
        if let currentShow = calendarAssistant.getCurrentShow(){
            self.currentShowLabel.numberOfLines = 2
            self.currentShowLabel.text = "Listening to " + currentShow.getTitle() + " \nDJ: " + currentShow.getDJ()
            self.currentShowLabel.sizeToFit()
        }
        // if nothing returned from server, label is blank
    }
    
}
