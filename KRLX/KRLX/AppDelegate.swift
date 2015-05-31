//
//  AppDelegate.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //For navigation bar item
    var buttonPlay: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var buttonPause: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var playButtonItem: UIBarButtonItem!
    var pauseButtonItem: UIBarButtonItem!
    //var setNavigationItem: Bool = false
    
    
    func playRadio(){
        player.play()
        self.window?.rootViewController?.navigationItem.setRightBarButtonItem(self.pauseButtonItem, animated: false)
        //window?.rootViewController?.navigationController?.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: false)
 
    }
    
    func pauseRadio(){
        player.pause()
        self.window?.rootViewController?.navigationItem.setRightBarButtonItem(self.playButtonItem, animated: false)
        //window?.rootViewController?.navigationController?.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: false)
        
    }
    
    @IBAction func musicButtonClicked(sender: AnyObject){
        if self.isPlaying {
            self.pauseRadio()
            //setNavigationItem = true
            //window?.rootViewController?.navigationController?.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: false)
            window?.rootViewController?.navigationItem.setRightBarButtonItem(self.playButtonItem, animated: false)
            self.isPlaying = false
            
        }else{
            self.playRadio()
            //setNavigationItem = true
            window?.rootViewController?.navigationItem.setRightBarButtonItem(self.pauseButtonItem, animated: false)
            //window?.rootViewController?.navigationController?.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: false)
            //navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: false)
            self.isPlaying = true
            
        }
    }
    
    
    //For live streaming view
    var player:AVPlayer = AVPlayer(URL: NSURL(string: "http://radio.krlx.org/mp3/high_quality"))

    var isPlaying = false    

    var currentVolume: Float = 0.5
    
    
    var loadedArticleHeaders = NSMutableArray()
    var loadedShowHeaders = NSMutableArray()
    var loadedSongHeaders = NSMutableArray()
    
    var refreshTimer : NSTimer!
    var subscribers = NSMutableArray()
    var firstTimerRun = true
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        return true
    }
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.setUpTimer()
        
        // Initialize play/pause buttons
        self.buttonPlay.frame = CGRectMake(0, 0, 40, 40)
        self.buttonPlay.setImage(UIImage(named:"play.png"), forState: UIControlState.Normal)
        self.buttonPlay.addTarget(self, action: "musicButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.playButtonItem = UIBarButtonItem(customView: self.buttonPlay)

        self.buttonPause.frame = CGRectMake(0, 0, 40, 40)
        self.buttonPause.setImage(UIImage(named:"pause.png"), forState: UIControlState.Normal)
        self.buttonPause.addTarget(self, action: "musicButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.pauseButtonItem = UIBarButtonItem(customView: self.buttonPause)
        
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
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //opens a file
    func openFile (fileName: String, fileExtension: String, utf8: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileExtension)
        var error: NSError?
        return NSFileManager().fileExistsAtPath(filePath!) ? String(contentsOfFile: filePath!, encoding: utf8, error: &error)! : nil
    }
    
    func setUpTimer(){

        //refreshes at next half hour
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
    
    func subscribe(viewController : UIViewController){
        self.subscribers.addObject(viewController)
    }
    func unssubscribe(viewController : UIViewController){
        self.subscribers.removeObject(viewController)
    }
    
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

