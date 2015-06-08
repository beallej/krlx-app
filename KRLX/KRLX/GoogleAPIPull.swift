//
//  GoogleAPIPull.swift
//  KRLX
//  This class pull data from Google Calendar API and update the global show list
//
//  Created by Phuong Dinh on 5/25/15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation

class GoogleAPIPull {
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    init(){
    }
  
    
    
    // This function pull KRLX calendar using Google Calendar API,
    // parse info and display it in readable form
    func pullKRLXGoogleCal(delegate: DataObserver){
        
        var show_arrays = [ShowHeader]()//initiate a show arrays that hold all the future shows in 1 week
        
        // ApiCode from URLString comes from the GoogleCalCredentials.txt file that is not included in repository
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
                        // Get array of show list by parsing JSON then make the show list global
                        var newShowList = NSMutableArray(array: self.parseJsonGetShows(jsonResult))
                        self.appDelegate.loadedShowHeaders = newShowList
                        delegate.updateView()
                    } else {
                        // Handle error when json is nil
                        println("Json is empty. Google API is not pulling or there is no show")
                    }
            } else {
                // Handle error when urldata nil
                println("No internet connection or Google API totally depreciated.")
            }
            })
        //Continue with other tasks
        task.resume()

        }
    
    
    
    // This function take in a time string of format 2015-05-21T05:30:00-05:00
    // Return an array of prettified [time, date]
    func prettifyTimeLabel(time: String) -> [String] {
        
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
    
    
    
    
    // Get current time in UTC and 7.5 days after time to substitute in the Google API String -> time return in format 2015-05-23T10%3A44%3A59Z
    func getStartEndScheduleTime () -> (curTime: String, endTime: String){
        
        let now = NSDate()
        let nextWeek = NSDate().dateByAddingTimeInterval(60*60*24*8)//number of seconds in 8 days (including today)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH'%3A'mm'%3A'ss"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        var dateStringNow = dateFormatter.stringFromDate(now) as String //current time
        var dateStringNextWeek = dateFormatter.stringFromDate(nextWeek) as String //this time next week
        
        return (dateStringNow, dateStringNextWeek)
    }
    
    
    
    
    // This helper function pass JSON from the main function, get show title, DJ, time
    // Return show lists
    func parseJsonGetShows(jsonResult: NSDictionary!) -> [ShowHeader]{
        
        var show_arrays: [ShowHeader] = []
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
        return show_arrays
    }
}