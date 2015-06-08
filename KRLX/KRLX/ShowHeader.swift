//
//  ShowHeader.swift
//  KRLX
//
//  This class define each show's properties (including title, DJ, start, end time and date of show)
//  Created by Phuong Dinh on 5/20/15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation

class ShowHeader {
    var title : String
    var start : String
    var end : String
    var DJ : String
    var date: String
    
    init (titleString: String, startString: String, endString: String, DJString: String, dateString:String){
        self.title = titleString
        self.start = startString
        self.end = endString
        self.DJ = DJString
        self.date = dateString // initialize to nil
        if dateString != "" {
            self.date = self.formatDate(dateString)
        }
    }
    func getTitle() -> String{
        return self.title
    }
    func getDJ() -> String{
        return self.DJ
    }
    func getStartTime() -> String{
        return self.start
    }
    func getEndTime() -> String{
        return self.end
    }
    func getDate() -> String{
        return self.date
    }
    
    //Returns date as "Mon, Dec 21",for example
    func formatDate(dateString : String) -> String{
        
        //converts string to nsdate
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "America/Chicago")
        let showDate = dateFormatter.dateFromString(dateString)
        
        //converts nsdate to preferred format, then back to a string
        var prettyDateFormatter = NSDateFormatter()
        
        //DayOfWeek-MonthAsString-DayNumber
        prettyDateFormatter.dateFormat = "EEEE-LLLL-dd"
        prettyDateFormatter.timeZone = NSTimeZone(abbreviation: "America/Chicago")
        let prettyDateString = prettyDateFormatter.stringFromDate(showDate!)
        var dateStringArray = prettyDateString.componentsSeparatedByString("-")
        let day = dateStringArray[0]
        let month = dateStringArray[1]
        
        //Shorten December-> Dec, Monday -> Mon, for example
        dateStringArray[0] = day.substringWithRange(Range<String.Index>(start: day.startIndex, end: advance(day.startIndex, 3)))
        dateStringArray[1] = month.substringWithRange(Range<String.Index>(start: month.startIndex, end: advance(month.startIndex, 3)))
        
        //                    Day of week         ,   Month                  Day
        let finalDateString = dateStringArray[0]+", "+dateStringArray[1]+" "+dateStringArray[2]
        return finalDateString
        
        
    }


    
}
