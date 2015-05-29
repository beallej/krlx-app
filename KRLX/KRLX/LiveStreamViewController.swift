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

class LiveStreamViewController: UIViewController, AVAudioPlayerDelegate , DataObserver{

    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIButton!
    
    // http://stackoverflow.com/questions/5655864/check-play-state-of-avplayer
    
    @IBOutlet weak var currentShowLabel: UILabel!
    
    @IBOutlet weak var volumeController: UISlider!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    
    var show_arrays = [ShowHeader]()
    var currentShowName: String = "show"
    var currentDJName: String = "DJ"
    var calendarAssistant = GoogleAPIPull()
    
    override func viewDidLoad() {
        self.appDelegate.subscribe(self)

        self.currentShowLabel.text = "Loading Show Name and DJ Name..."
        //dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {

           self.calendarAssistant.pullKRLXGoogleCal()
//           dispatch_async(dispatch_get_main_queue()) {
 //               self.setCurrentShow()
//            }
        //}
        //volumeController.setThumbImage(<#image: UIImage?#>, forState: <#UIControlState#>)
        volumeController.value = appDelegate.currentVolume
        appDelegate.player.volume = appDelegate.currentVolume
        
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
                // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
//        self.appDelegate.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.appDelegate.unssubscribe(self)
    }
    
    
    func notify() {
        self.setCurrentShow()
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
        appDelegate.currentVolume = Float(sender.value)
        appDelegate.player.volume = appDelegate.currentVolume
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentShow(){
        if let currentShow: ShowHeader = appDelegate.loadedShowHeaders[0] as? ShowHeader{
            self.currentShowLabel.numberOfLines = 3
            self.currentShowLabel.text = "Listening to " + currentShow.getTitle() + " \nDJ: " + currentShow.getDJ()
            self.currentShowLabel.sizeToFit()
        }
        // if nothing ever loaded from server, label is blank
    }
    
}
