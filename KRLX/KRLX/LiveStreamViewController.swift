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
    var show_arrays = [ShowHeader]()
    var currentShowName: String = "show"
    var currentDJName: String = "DJ"
    
    override func viewDidLoad() {
        self.currentShowLabel.text = ""
        getCurrentShow()
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
        
        // Do any additional setup after loading the view.
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrentShow(){
        var labelText: String = ""
        // This function pull KRLX calendar using Google Calendar API,
        // parse info and display it in readable form
        
        let curTime = getCurrentTime()
        var urlString = "https://www.googleapis.com/calendar/v3/calendars/cetgrdg2sa8qch41hsegktohv0%40group.calendar.google.com/events?singleEvents=true&orderBy=startTime&timeMin="+curTime+"Z&timeZone=America%2fChicago&maxResults=60&key=AIzaSyD-Lcm54auLNoxEPqxNYpq2SP4Jcldzq2I"
        let url = NSURL(string: urlString)
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = url
        request.HTTPMethod = "GET"
        var response: NSURLResponse?
        var error: NSError?
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var errorJSON: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            if (data != nil){
                let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: errorJSON) as? NSDictionary
                // Parse show content of NSDictionary
                if (jsonResult != nil){
                    if let allitems_wrapper = jsonResult["items"] as? NSArray{
                        for index in 0...0{
                            var ShowTitle = allitems_wrapper[0]["summary"] as! String
                            var startTimeArray = (allitems_wrapper[0]["start"] as! NSDictionary)["dateTime"] as! String
                            var startTime = self.prettifyTimeLabel(startTimeArray)[0]
                            var date = self.prettifyTimeLabel(startTimeArray)[1] as String
                            var endTime = (allitems_wrapper[0]["end"] as! NSDictionary)["dateTime"] as! String
                            endTime = self.prettifyTimeLabel(endTime)[0]
                            var ShowDJ: String
                            if let DJ:String = allitems_wrapper[0]["description"] as? String {
                                ShowDJ = DJ
                            }
                            else {
                                ShowDJ = ""
                            }
                            var show = ShowHeader(titleString: ShowTitle, startString: startTime, endString: endTime, DJString: ShowDJ, dateString: date)
                            self.show_arrays.append(show)
                        }
                    }
                    var newShowList = NSMutableArray(array: self.show_arrays)
                    if newShowList != sharedData.loadedShowHeaders{
                        sharedData.loadedShowHeaders = newShowList
                        self.setCurrentShow()
                        
                    }
                }
                    
                else
                {
                    self.currentShowLabel.text = "Whoops! Something's wrong with the server"
                }
            }
                
                //no response
            else{
                self.currentShowLabel.text = "No internet connection"
            }
        })
    }

    
    func getCurrentTime () -> String{
        // Get current time in UTC to substitute in the Google API String
        // timeMin=2015-05-23T10%3A44%3A59Z&timeZone=America%2FChicago
        let now = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH'%3A'mm'%3A'ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        var dateString = dateFormatter.stringFromDate(now) as String
        return dateString
    }
    
    func prettifyTimeLabel(time: String) -> [String]
        // This function take in a time string of format 2015-05-21T05:30:00-05:00
        // Return an array of prettified [time, date]
    {
        var finalTime : [String] = []
        //2015-05-21T05:30:00-05:00 --> 05:30:00
        var tm = time.componentsSeparatedByString("T")[1].componentsSeparatedByString("-")[0]
        var date = time.componentsSeparatedByString("T")[0]
        
        //05:30:00 --> 5:30
        var hour = tm.substringWithRange(Range<String.Index>(start: tm.startIndex, end: advance(tm.endIndex, -6)))
        var minute = tm.substringWithRange(Range<String.Index>(start: advance(tm.startIndex, 2), end: advance(tm.endIndex, -3)))
        var hourNumber = hour.toInt()
        
        //Convert 24 hour scale to 12 hour scale
        if hourNumber > 12 {
            hourNumber = hourNumber! % 12
            finalTime.append(hourNumber!.description + minute + "pm")
        }
        else if hourNumber == 12 {
            finalTime.append(hourNumber!.description + minute + "pm")
        }
        else if hourNumber == 0 {
            finalTime.append("12" + minute + "am")
        }
        else{
            finalTime.append(hourNumber!.description+minute+"am")
        }
        finalTime.append(date)
        return finalTime
        
    }


    func setCurrentShow(){
        let show = sharedData.loadedShowHeaders[0] as! ShowHeader
        self.currentShowLabel.text = "Listening to " + show.getTitle() + " by " + show.getDJ()
    }
    
}
