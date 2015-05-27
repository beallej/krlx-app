//
//  SongHeader.swift
//  KRLX
//
//  Created by Phuong Dinh on 5/27/15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation

class SongHeader {
    var title : String
    var singer: String
    
    init (titleString: String, singerString:String){
        self.title = titleString
        self.singer = singerString
    }
    func getTitle() -> String{
        return self.title
    }
    func getSinger() -> String{
        return self.singer
    }
}