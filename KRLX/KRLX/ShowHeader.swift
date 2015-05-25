//
//  ShowHeader.swift
//  KRLX
//
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

    
}
