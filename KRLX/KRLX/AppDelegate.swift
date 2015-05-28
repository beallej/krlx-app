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
class AppDelegate: UIResponder, UIApplicationDelegate, DataObserver {

    var window: UIWindow?
    var player:AVPlayer = AVPlayer(URL: NSURL(string: "http://radio.krlx.org/mp3/high_quality"))

    var isPlaying = false    
    var currentVolume: Float = 0.5
    
    
    var loadedArticleHeaders = NSMutableArray()
    var loadedShowHeaders = NSMutableArray()
    var loadedSongHeaders = NSMutableArray()
    
    var refreshTimer : NSTimer!
    var subscribers = NSMutableArray()


    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
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
        self.subscribers.addObject(self)
        let timeInt = self.getTimeToRefresh()
        let timeSeconds : NSTimeInterval = Double(timeInt)*60.0
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(timeSeconds, target: self, selector: Selector("notify"), userInfo: nil, repeats: false)
//        
//        init(fireDate date: NSDate,
//            interval seconds: NSTimeInterval,
//            target target: AnyObject,
//            selector aSelector: Selector,
//            userInfo userInfo: AnyObject?,
//            repeats repeats: Bool)
    }
    func notify(){
        self.subscribers.removeObject(self)
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1800.00, target: self, selector: Selector("notify"), userInfo: nil, repeats: true)
    }
//    func refreshData(){
//        
//        //refreshes every 30 minutes
//        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1800.00, target: self, selector: Selector("notify"), userInfo: nil, repeats: true)
//        
//    }
    
    //gets time between now and next 30 min mark, so we know when to refresh next
    func getTimeToRefresh() -> Int{
        let now = NSDate()
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "mm"
//        var minString = dateFormatter.stringFromDate(now) as String
//        let minInt = minString.toInt()!
//        
//        
//        var timeToRefresh : Int
//        if minInt <= 30 {
//            timeToRefresh = 30 - minInt
//        }
//        else{
//            timeToRefresh = 60 - minInt
//        }
        //return timeToRefresh
        
        //http://stackoverflow.com/questions/15584238/get-the-future-time-as-nsdate
        let calendar = NSCalendar.currentCalendar()
        var components = NSDateComponents.new()
        components.minute = 30
        components.hour = 0
        let date = calendar.dateByAddingComponents(components, toDate: now, options: nil)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm','ss"
        var dateString : String = dateFormatter.stringFromDate(date!)
        var dateArray = dateString.componentsSeparatedByString(",")
        var timeToRefresh = dateArray[0].toInt()!*60 + dateArray[1].toInt()!
        return timeToRefresh

//        
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *components = [NSDateComponents new];
//        components.minute = 30;
//        components.hour = 1;
//        NSDate *date = [calendar dateByAddingComponents:components toDate:< your date > options:0];
//        
        
    }
    
    
    
    
    func subscribe(viewController : UIViewController){
        self.subscribers.addObject(viewController)
    }
    func unssubscribe(viewController : UIViewController){
        let m = subscribers.count
        self.subscribers.removeObject(viewController)
        print (m - subscribers.count)
    }
    func timerHandler(){
        for subscriber in self.subscribers{
            let dataSubscriber = subscriber as! DataObserver
            dataSubscriber.notify()
        }
        //for each subscriber, ssubscriber.notify()
    }



}

