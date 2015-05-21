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
    
    init (titleString: String, startString: String, endString: String, DJString: String){
        self.title = titleString
        self.start = startString
        self.end = endString
        self.DJ = DJString
    }
    func getTitle() -> String{
        println(self.title)
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

    
}
