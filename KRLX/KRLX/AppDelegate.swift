//
//  AppDelegate.swift
//  KRLX
//
//  Created by Simon Ng on 2/2/15.
//  Adapted by KRLXpert on May 2015
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var session: AVAudioSession = AVAudioSession.sharedInstance()

    
    
    //For live streaming view
    //The fake URL is obtained from: http://luciancancescu.blogspot.com/2015/02/how-to-build-ios-radio-app-with-swift.html
    
    /*UNCOMMENT LINE BELOW AND COMMENT OTHER LINE TO GET KRLX*/
    //var player:AVPlayer = AVPlayer(URL: NSURL(string: "http://radio.krlx.org/mp3/high_quality"))
    var player:AVPlayer = AVPlayer(URL: NSURL(string: "http://www.radiobrasov.ro/listen.m3u"))

    var isPlaying = false
    

    var currentVolume: Float = 0.5
    
    
    var loadedArticleHeaders = NSMutableArray()
    var loadedShowHeaders = NSMutableArray()
    var loadedSongHeaders = NSMutableArray()
    
    var refreshTimer : NSTimer!
    var subscribers = NSMutableArray()
    
    //The first time, timer is for less thann 30 minute interval
    var firstTimerRun = true
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //Set up background mode for audio
        //Reference: http://stackoverflow.com/questions/27280041/ios-swift-streaming-app-does-not-play-music-in-background-mode
        var activeError: NSError? = nil
        self.session.setActive(true, error: &activeError)
        
        if let actError = activeError {
            NSLog("Error setting audio active: \(actError.code)")
        }
        
        var categoryError: NSError? = nil
        self.session.setCategory(AVAudioSessionCategoryPlayback, error: &categoryError)
        
        if let catError = categoryError {
            NSLog("Error setting audio category: \(catError.code)")
        }
        
        return true
    }
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.setUpTimer()
        
        return true

    }
    func preferredStatusBarStyle()-> UIStatusBarStyle{
        return UIStatusBarStyle.LightContent
    }
    
   
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        session.setActive(true, withOptions: nil, error: nil)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        session.setActive(true, withOptions: nil, error: nil)

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //Sets up the menu and hamburger button
    func setUpSWRevealVC(vc: UIViewController, menuButton: UIBarButtonItem){
        if vc.revealViewController() != nil {
            menuButton.target = vc.revealViewController()
            menuButton.action = "revealToggle:"
            vc.view.addGestureRecognizer(vc.revealViewController().panGestureRecognizer())
        }
    }
    
    //Sets up play/pause toggle in viewcontrollers
    func setUpPlayPause(vc: PlayPause){
        self.setButtons(vc)
        self.addRightNavItemOnView(vc)
    }
    
    
    ///Adding play/pause button
    func addRightNavItemOnView(vc: PlayPause)
    {
        var rightBarButtonItem: UIBarButtonItem!

        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isPlaying {
            rightBarButtonItem = UIBarButtonItem(customView: vc.buttonPause)
            
        }else{
            rightBarButtonItem = UIBarButtonItem(customView: vc.buttonPlay)
        }
        vc.navigationItem.setRightBarButtonItem(rightBarButtonItem!, animated: false)
        
    }
    
    
    func musicButtonClicked(vc: PlayPause) {
        if self.isPlaying {
            self.pauseRadio(vc)
            self.isPlaying = false
            
        }else{
            self.playRadio(vc)
            self.isPlaying = true
            
        }
    }
    
    func playRadio(vc: PlayPause){
        self.player.play()
        let rightBarButtonItem = UIBarButtonItem(customView: vc.buttonPause)
        vc.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
    }
    
    func pauseRadio(vc: PlayPause){
        self.player.pause()
        let rightBarButtonItem = UIBarButtonItem(customView: vc.buttonPlay)
        vc.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
    }
    
    //Create play/pause button for navigaation bar
    func setButtons(vc: PlayPause){
        
        vc.buttonPlay.frame = CGRectMake(0, 0, 40, 40)
        vc.buttonPlay.setImage(UIImage(named:"play.png"), forState: UIControlState.Normal)
        vc.buttonPlay.addTarget(vc as! UIViewController, action: "musicButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        vc.buttonPause.frame = CGRectMake(0, 0, 40, 40)
        vc.buttonPause.setImage(UIImage(named:"pause.png"), forState: UIControlState.Normal)
        vc.buttonPause.addTarget(vc as! UIViewController, action: "musicButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    
    //opens a file
    func openFile (fileName: String, fileExtension: String, utf8: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileExtension)
        var error: NSError?
        return NSFileManager().fileExistsAtPath(filePath!) ? String(contentsOfFile: filePath!, encoding: utf8, error: &error)! : nil
    }
    
    //Sets up timer to go off at next half-hour mark
    func setUpTimer(){

        let timeInt = self.getTimeToRefresh()
        var timeSeconds : NSTimeInterval = Double(timeInt)
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(timeSeconds, target: self, selector: Selector("handleTimer"), userInfo: nil, repeats: false)

    }
    
    //gets time between now and next 30 min mark, so we know when to refresh next
    func getTimeToRefresh() -> Int{
        
        let now = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm','ss"
        var dateString : String = dateFormatter.stringFromDate(now)
        var dateArray = dateString.componentsSeparatedByString(",")
        var minInt = dateArray[0].toInt()!
        let secInt = dateArray[1].toInt()!      
        
        
        var timeToRefresh : Int
        if minInt < 30 {
            timeToRefresh = 30 - minInt
        }
        else{
            timeToRefresh = 60 - minInt
        }
        timeToRefresh = timeToRefresh*60 + secInt
        return timeToRefresh
    
        
    }
    
    //A view controller subscribes when it wants to get its data updated
    func subscribe(viewController : UIViewController){
        self.subscribers.addObject(viewController)
    }
    func unssubscribe(viewController : UIViewController){
        self.subscribers.removeObject(viewController)
    }
    
    //Refreshes ever 30 minutes
    func handleTimer(){
        
        //The first time, the timer runs for less time to get to next half hour mark
        if (self.firstTimerRun){
            self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1800.00, target: self, selector: Selector("handleTimer"), userInfo: nil, repeats: true)
            self.firstTimerRun = false
        }
        
        //Notify subscribers of change!
        for subscriber in self.subscribers{
            let dataSubscriber = subscriber as! DataObserver
            dataSubscriber.notify()
        }
    }




}

