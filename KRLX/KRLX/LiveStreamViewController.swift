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
  
        //volumeController.value = appDelegate.currentVolume
        self.appDelegate.player.volume = appDelegate.currentVolume
        
        if self.appDelegate.isPlaying {
            let image = UIImage(named: "pause2") as UIImage?
            //let image = UIImage(named: "pause2") as UIImage?
            playButton.setBackgroundImage(image, forState: UIControlState.Normal)
            
        }else{
            let image = UIImage(named: "play2") as UIImage?
            //let image = UIImage(named: "play2") as UIImage?
            playButton.setBackgroundImage(image, forState: UIControlState.Normal)
        }
        
        //Connect to menu
        self.appDelegate.setUpSWRevealVC(self, menuButton: self.menuButton)

        setVolumeButton()
        
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
        self.appDelegate.player.play()
        let image = UIImage(named: "pause2") as UIImage?
        self.playButton.setBackgroundImage(image, forState: UIControlState.Normal)
    }
    
    func pauseRadio() {
        
        self.appDelegate.player.pause()
        let image = UIImage(named: "play2") as UIImage?
        self.playButton.setBackgroundImage(image, forState: UIControlState.Normal)
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
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            //let popoverViewController = segue.destinationViewController as! UIViewController
            let popoverViewController = segue.destinationViewController as! VolumeViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }*/
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
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
        
        setVolumeButton()
    }
    
    func setVolumeButton(){
        self.volumeButton.frame = CGRectMake(0, 0, 30, 30)
        if (appDelegate.currentVolume == 0){
            self.volumeButton.setImage(UIImage(named:"volumeLevel0.png"), forState: UIControlState.Normal)
        }else if (appDelegate.currentVolume < 0.4) {
            self.volumeButton.setImage(UIImage(named:"volumeLevel1.png"), forState: UIControlState.Normal)
        }else if (appDelegate.currentVolume < 0.8) {
            self.volumeButton.setImage(UIImage(named:"volumeLevel2.png"), forState: UIControlState.Normal)
        }else{
            self.volumeButton.setImage(UIImage(named:"volumeLevel4.png"), forState: UIControlState.Normal)
        }
        
        self.volumeButton.addTarget(self, action: "showPopover:", forControlEvents: UIControlEvents.TouchUpInside)
        self.volumeControllerButton = UIBarButtonItem(customView: volumeButton)
        self.navigationItem.setRightBarButtonItem(self.volumeControllerButton, animated: false)
    }
    //Makes keyboard disappear when you touch the tableview, because you're done searching
    func didTapOnBackgroundView(recognizer: UIGestureRecognizer) {
        self.popoverContent?.dismissViewControllerAnimated(false, completion: nil)
    }
    
}
