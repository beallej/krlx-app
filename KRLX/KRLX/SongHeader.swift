//
//  SongHeader.swift
//  KRLX
//
//  This class define each song properties, including title, artist, imageURL (only 1st recently heard song has URL)
//  Created by Josie Bealle, Phuong Dinh, Maraki Ketema, Naomi Yamamoto on 5/27/15.
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