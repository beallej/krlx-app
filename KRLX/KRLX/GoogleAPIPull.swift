//
//  GoogleAPIPull.swift
//  KRLX
//
//  Created by Phuong Dinh on 5/25/15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation
class GoogleAPIPull {
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    init(){
    }
    
    func pullKRLXGoogleCal(delegate: DataObserver){
        // This function pull KRLX calendar using Google Calendar API,
        // parse info and display it in readable form
        var show_arrays = [ShowHeader]()
        
        let apiCode = self.appDelegate.openFile("GoogleCalCredentials", fileExtension: "txt")!
        let curTime = getStartEndScheduleTime().curTime
        let endTime = getStartEndScheduleTime().endTime
        
        
        var urlString = "https://www.googleapis.com/calendar/v3/calendars/cetgrdg2sa8qch41hsegktohv0%40group.calendar.google.com/events?singleEvents=true&orderBy=startTime&timeMin="+curTime+"Z&timeMax="+endTime+"Z&timeZone=America%2fChicago&key="+apiCode
        
        let url = NSURL(string: urlString)
  
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url!, completionHandler: { (urlData: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let data = urlData {
        
                var errorJSON: AutoreleasingUnsafeMutablePointer<NSError?> = nil
                
                    let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: errorJSON) as? NSDictionary
                
                // Parse show content of NSDictionary
                    if (jsonResult != nil){
                        if let allitems_wrapper = jsonResult["items"] as? NSArray{
                            for item in allitems_wrapper {
                                var ShowTitle = item["summary"] as! String
                                var startTimeArray = (item["start"] as! NSDictionary)["dateTime"] as! String
                                var startTime = self.prettifyTimeLabel(startTimeArray)[0]
                                var date = self.prettifyTimeLabel(startTimeArray)[1] as String
                                var endTime = (item["end"] as! NSDictionary)["dateTime"] as! String
                                endTime = self.prettifyTimeLabel(endTime)[0]
                                var ShowDJ: String
                                if let DJ:String = item["description"] as? String {
                                    ShowDJ = DJ
                                }
                                else {
                                    ShowDJ = ""
                                }
                                var show = ShowHeader(titleString: ShowTitle, startString: startTime, endString: endTime, DJString: ShowDJ, dateString: date)
                                show_arrays.append(show)
                            }
                            var lastLine = ShowHeader(titleString: "For more upcoming shows visit krlx.org", startString: "", endString: "", DJString: "", dateString: "")
                            show_arrays.append(lastLine)
                        }
                        var newShowList = NSMutableArray(array: show_arrays)
                        self.appDelegate.loadedShowHeaders = newShowList
                        delegate.updateView()
                    }
                        
                    else
                    {
                        //json is nil
                    }
            }
                
            else {
                //urldata nil
            }
            })
        task.resume()

        }
    
    
    // This function take in a time string of format 2015-05-21T05:30:00-05:00
    // Return an array of prettified [time, date]
    func prettifyTimeLabel(time: String) -> [String]
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
    
    func getStartEndScheduleTime () -> (curTime: String, endTime: String){
        // Get current time in UTC to substitute in the Google API String
        // timeMin=2015-05-23T10%3A44%3A59Z&timeZone=America%2FChicago
        let now = NSDate()
        let nextWeek = NSDate().dateByAddingTimeInterval(60*60*24*7)//number of seconds in 7 days
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH'%3A'mm'%3A'ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        var dateStringNow = dateFormatter.stringFromDate(now) as String
        var dateStringNextWeek = dateFormatter.stringFromDate(nextWeek) as String
        
        return (dateStringNow, dateStringNextWeek)
    }

}