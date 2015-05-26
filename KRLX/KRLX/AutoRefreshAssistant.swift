//
//  AutoRefreshAssistant.swift
//  KRLX
//
//  Created by Josie Bealle on 26/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation

class AutoRefreshAssistant {
    var refreshTimer : NSTimer?
    var selector : Selector
    
    init(selector: Selector){
        self.selector = selector
        self.setUpTimer()
    }
    
    func setUpTimer(){
        
        //refreshes at next half hour
        let timeInt = self.getTimeToRefresh()
        let timeSeconds : NSTimeInterval = Double(timeInt)*60.0
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(timeSeconds, target: self, selector: self.selector, userInfo: nil, repeats: false)
    }

    
    func getTimeToRefresh() -> Int{
        let now = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm"
        var minString = dateFormatter.stringFromDate(now) as String
        let minInt = minString.toInt()!
        
        
        var timeToRefresh : Int
        if minInt <= 30 {
            timeToRefresh = 30 - minInt
        }
        else{
            timeToRefresh = 60 - minInt
        }
        return timeToRefresh
        
        
    }


}
