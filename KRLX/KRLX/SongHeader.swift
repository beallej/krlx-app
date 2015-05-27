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
    var artist: String
    var url: String?
    
    init (titleString: String, singerString:String, urlString:String){
        self.title = titleString
        self.artist = singerString
        self.url = urlString
    }
    init (titleString: String, singerString:String){
        self.title = titleString
        self.artist = singerString
    }
    func getTitle() -> String{
        return self.title
    }
    func getArtist() -> String{
        return self.artist
    }
    
    func setURL(url : String){
        self.url = url
    }
    func getURL() -> String?{
        return self.url
    }
}