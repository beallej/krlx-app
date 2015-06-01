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

class LiveStreamViewController: UIViewController, AVAudioPlayerDelegate , DataObserver, UIPopoverPresentationControllerDelegate{

    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIButton!
    
    // http://stackoverflow.com/questions/5655864/check-play-state-of-avplayer
    
    @IBOutlet weak var currentShowLabel: UILabel!
    
    
    @IBOutlet weak var volumeControllerButton: UIBarButtonItem!
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    
    var show_arrays = [ShowHeader]()
    var currentShowName: String = "show"
    var currentDJName: String = "DJ"
    var calendarAssistant = GoogleAPIPull()
    
    override func viewDidLoad() {
        self.appDelegate.subscribe(self)
        self.calendarAssistant.pullKRLXGoogleCal(self)
  
        //volumeController.value = appDelegate.currentVolume
        self.appDelegate.player.volume = appDelegate.currentVolume
        
        if self.appDelegate.isPlaying {
            let image = UIImage(named: "pause") as UIImage?
            playButton.setBackgroundImage(image, forState: UIControlState.Normal)
            
        }else{
            let image = UIImage(named: "play") as UIImage?
            playButton.setBackgroundImage(image, forState: UIControlState.Normal)
        }
        
        //Connect to menu
        self.appDelegate.setUpSWRevealVC(self, menuButton: self.menuButton)

        
        
        //self.volumeControllerButton.setBackgroundImage(volumeImg, forState: .Normal, barMetrics: .Default)
        /*
        var volumeButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        volumeButton.frame = CGRectMake(0, 0, 40, 40)
        volumeButton.setImage(UIImage(named:"volumeIcon.png"), forState: UIControlState.Normal)
        self.volumeControllerButton = UIBarButtonItem(customView: volumeButton)
        */
                // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.appDelegate.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.appDelegate.unssubscribe(self)
    }
    
    
    func notify() {
        self.calendarAssistant.pullKRLXGoogleCal(self)
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        if self.appDelegate.isPlaying {
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
    
    /*
    @IBAction func changeVolume(sender: UISlider) {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.currentVolume = Float(sender.value)
        appDelegate.player.volume = appDelegate.currentVolume
    }
*/
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView(){
        if let currentShow: ShowHeader = self.appDelegate.loadedShowHeaders[0] as? ShowHeader{
            
            //UI updates must be in main queue, else there is a delay :(
            dispatch_async(dispatch_get_main_queue()) {
            
                self.currentShowLabel.numberOfLines = 4
                self.currentShowLabel.text = "Listening to " + currentShow.getTitle()
                if currentShow.getDJ() != ""{
                    self.currentShowLabel.text = self.currentShowLabel.text! + " \nDJ: " + currentShow.getDJ()
                }
                self.currentShowLabel.sizeToFit()
            }
        }
        // if nothing ever loaded from server, label is blank
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            //let popoverViewController = segue.destinationViewController as! UIViewController
            let popoverViewController = segue.destinationViewController as! VolumeViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
}
