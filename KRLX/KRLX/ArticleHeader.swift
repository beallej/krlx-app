//
//  ArticleHeader.swift
//  KRLX
//
//  Created by Josie Bealle and Phuong Dinh on 13/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//


class ArticleHeader {
    var author : String
    var title : String
    var date : [String]
    var url : String
    var content : String?
    let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
    let longMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate
       
    init (authorString: String, titleString: String, dateString: String, urlString: String){
        self.author = authorString
        self.title = titleString
        self.url = urlString
        
        var dateArr = split(dateString) {$0 == "-"}
        var monthNum = dateArr[1].toInt()! - 1
        let monthstr = self.months[monthNum]
        let longMonth = self.longMonths[monthNum]
        
        //[day, MONTH,  year]: ex. ["21", "DEC", "1993"]
        self.date = [dateArr[2], monthstr, dateArr[0], longMonth]
        
    }

    func getTitle() -> String{
        return self.title
    }
    func getAuthor() -> String{
        return self.author
    }
    func getDate() -> [String]{
        return self.date
    }
    func getURL() -> String{
        return self.url
    }
    func getContent() -> String?{
        return self.content
    }
    
    
}