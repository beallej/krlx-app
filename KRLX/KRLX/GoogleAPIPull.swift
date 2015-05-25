//
//  GoogleAPIPull.swift
//  KRLX
//
//  Created by Phuong Dinh on 5/25/15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation
class GoogleAPIPull {
    init(){
    }

    /*
    func pullKRLXGoogleCal() {
        // This function pull KRLX calendar using Google Calendar API,
        // parse info and display it in readable form
        
        let curTime = getCurrentTime()
        var urlString = "https://www.googleapis.com/calendar/v3/calendars/cetgrdg2sa8qch41hsegktohv0%40group.calendar.google.com/events?singleEvents=true&orderBy=startTime&timeMin="+curTime+"Z&timeZone=America%2fChicago&maxResults=60&key=AIzaSyD-Lcm54auLNoxEPqxNYpq2SP4Jcldzq2I"
        let url = NSURL(string: urlString)
        //
        //let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/cetgrdg2sa8qch41hsegktohv0%40group.calendar.google.com/events?singleEvents=true&orderBy=startTime&timeMin=2015-05-23T10%3A44%3A59Z&timeZone=America%2FChicago&maxResults=100&key=AIzaSyD-Lcm54auLNoxEPqxNYpq2SP4Jcldzq2I")
        
        
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
                            self.show_arrays.append(show)
                            
                        }
                    }
                    var newShowList = NSMutableArray(array: self.show_arrays)
                    if newShowList != sharedData.loadedShowHeaders{
                        sharedData.loadedShowHeaders = newShowList
                        self.setFirstShow()
                        self.tableView?.reloadData()
                        
                    }
                    self.spinnyWidget.stopAnimating()
                }
                    
                else
                {
                    self.currentShowLabel.text = "Whoops! Something's wrong with the server"
                    self.spinnyWidget.stopAnimating()
                }
            }
                
                //no response
            else{
                self.currentShowLabel.text = "No internet connection"
                self.spinnyWidget.stopAnimating()
            }
        })
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
*/
}