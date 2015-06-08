//
//  LiveStreamViewController.swift
//  KRLX
//
//  Created by Josie Bealle, Phuong Dinh, Maraki Ketema, Naomi Yamamoto on 07/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class LiveStreamViewController: UIViewController, AVAudioPlayerDelegate , DataObserver, UIPopoverPresentationControllerDelegate{

    //Hamburger button
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    
    //Playback
    @IBOutlet weak var playButton: UIButton!
    var imagePlay = UIImage(named: "play2") as UIImage?
    var imagePause = UIImage(named: "pause2") as UIImage?
    
    // http://stackoverflow.com/questions/5655864/check-play-state-of-avplayer
    @IBOutlet weak var currentShowLabel: UILabel!
    
    //Setting background image
    @IBOutlet weak var bkgdImage: UIImageView!
    var volumeControllerButton: UIBarButtonItem!
    var volumeButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var popoverContent :UIViewController?
    let tap = UIGestureRecognizer()


    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    var show_arrays = [ShowHeader]()
    var currentShowName: String = "show"
    var currentDJName: String = "DJ"
    var calendarAssistant = GoogleAPIPull()
    
    override func viewDidLoad() {
        self.appDelegate.subscribe(self)
        self.calendarAssistant.pullKRLXGoogleCal(self)
  
        //Setting volume control to curret volume
        self.appDelegate.player.volume = appDelegate.currentVolume
        
        if self.appDelegate.isPlaying {
            self.playButton.setBackgroundImage(self.imagePause, forState: UIControlState.Normal)
            
        }else{
            self.playButton.setBackgroundImage(self.imagePlay, forState: UIControlState.Normal)
        }
        
        //Connect to menu
        self.appDelegate.setUpSWRevealVC(self, menuButton: self.menuButton)

        self.setVolumeButton()
        
        //Makes volume controller disappear when you click on background
        tap.addTarget(self, action: "didTapOnBackgroundView:")
        self.bkgdImage.addGestureRecognizer(tap)
        self.bkgdImage.userInteractionEnabled = true

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
    //Handels play/ pause button functionality
    @IBAction func buttonPressed(sender: AnyObject) {
        if self.appDelegate.isPlaying {
            self.pauseRadio()
            self.appDelegate.isPlaying = false
        }else{
            self.playRadio()
            self.appDelegate.isPlaying = true
            
        }
    }
    //plays live stream
    func playRadio() {
        self.appDelegate.player.play()
        self.playButton.setBackgroundImage(self.imagePause, forState: UIControlState.Normal)
    }
    //pauses live stream
    func pauseRadio() {
        self.appDelegate.player.pause()
        self.playButton.setBackgroundImage(self.imagePlay, forState: UIControlState.Normal)
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Creates text box where show description and DJ names are present
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
    }

    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    //Handels pop up volume controller
    @IBAction func showPopover(sender: AnyObject) {
        
        self.popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("volumeControllerPopView") as? UIViewController
        
        self.popoverContent!.modalPresentationStyle = .Popover
        var popover = popoverContent!.popoverPresentationController
        
        // set the size you wan to display
        self.popoverContent!.preferredContentSize = CGSizeMake(54, 150)
        popover!.delegate = self
        popover!.sourceView = self.view
        
        // position of the popover where it's showed
        popover!.sourceRect = CGRectMake(335,65,0,0)
        
        self.presentViewController(self.popoverContent!, animated: true, completion: nil)
    }
    
    
    //Sets up volume button
    func setVolumeButton(){
       self.volumeButton.frame = CGRectMake(0, 0, 30, 30)
       self.volumeButton.setImage(UIImage(named:"volumeLevel2.png"), forState: UIControlState.Normal)
       self.volumeButton.addTarget(self, action: "showPopover:", forControlEvents: UIControlEvents.TouchUpInside)
       self.volumeControllerButton = UIBarButtonItem(customView: volumeButton)
       self.navigationItem.setRightBarButtonItem(self.volumeControllerButton, animated: false)
    }
    
    
    //Makes keyboard disappear when you touch the tableview, because you're done searching
    func didTapOnBackgroundView(recognizer: UIGestureRecognizer) {
        self.popoverContent?.dismissViewControllerAnimated(false, completion: nil)
    }
    
}
