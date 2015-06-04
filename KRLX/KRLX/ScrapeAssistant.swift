//
//  ScrapeAssistant.swift
//  KRLX
//
//  Created by Phuong Dinh and Josie Bealle on 22/05/2015.
//  Based on the KRLX website structure on May 2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

class ScrapeAssistant {
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    init(){
    }
    
    //This function scrapes for an article content given url
    func scrapeArticle(url: String) -> String {
        // This function take in the URL as parameter of the Article and pass its content
        let myURLString = url
        var article_content = String()
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            //get raw content of the whole page
            if let error = error {
                println("Error : \(error)")
            } else {
                var err : NSError?
                // put htmlString into parser
                var parser = HTMLParser(html: myHTMLString!, error: &err)
                if err != nil {
                    exit(1)
                }
                var htmlBody = parser.body //get body of the html
                if let inputAllArticleNodes = htmlBody?.xpath("//div[@class='gk-article']") {
                    for node in inputAllArticleNodes {
                        article_content = node.rawContents
                        //Return the whole raw contents (including tags) into the WKWebView
                    }
                }
                else {
                    println("Error: Cannot find the gk-article div. Website structure changes.")
                }
            }
        } else {
            println("Error: \(myURLString) is not a valid URL OR internet connection is not here")
        }
        return String(article_content)
    }
    
    // This function scrapes for article title, date, author
    func scrapeArticleInfo(){
        var articles = [ArticleHeader]() //list of all articles (array)
        let myURLString = "http://www.krlx.org/" //The scraping list comes from the Home page
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            // myHTMLString is the whole html page
            if let error = error {
                println("Error : \(error)")
            } else {
                var err : NSError?
                var parser = HTMLParser(html: myHTMLString!, error: &err) //Parse content of HTML
                if err != nil {
                    println(err)
                    exit(1)
                }
                var htmlBody = parser.body
                //Get only the body of the HTML page
                if let allArticleNodes = htmlBody?.xpath("//div[@class='items-leading']/div[@class='items-leading'] | //div[@class='items-leading']/div[@class='leading-0']") {
                    // Get each article info wrapper following the website structure xpath
                    for node in allArticleNodes {
                        //process node into parser
                        var parser = HTMLParser(html: node.rawContents, error: &err)
                        var articleInfo   = parser.body
                        
                        //Get link and title of the article
                        var (article_header, article_url) = getArticleTitle_URL(articleInfo)
                        
                        //Get author
                        var author = getArticleAuthor(articleInfo)
                        
                        //Get date
                        var datetime = getArticleDate(articleInfo)
                        
                        // Make new object of ArticleHeader and append into the articles array
                        let article = ArticleHeader(authorString: author, titleString: article_header, dateString: datetime, urlString: article_url)
                        articles.append(article)
                    }
                }
            }
        } else {
            println("Error: \(myURLString) doesn't seem to be a valid URL")
        }
        self.appDelegate.loadedArticleHeaders = NSMutableArray(array: articles)
    }
    
    //This function scrape KRLX for list of recently heard
    func scrapeRecentlyHeard() {
        var songs = [SongHeader]() //global array of songs
        let myURLString = "http://www.krlx.org/"
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error {
                println("Error : \(error)")
            } else {
                var err : NSError?
                var parser = HTMLParser(html: myHTMLString!, error: &err)
                if err != nil {
                    println(err)
                    exit(1)
                }
                
                var htmlBody = parser.body
                
                // Get the div that contain the recently heard items
                if let inputAllArticleNodes = htmlBody?.xpath("//div[@class='custom']") {
                    // Recently Heard div is the 3rd div with class "custom"
                    var divRecentHeard = inputAllArticleNodes[2].rawContents
                    // Parse HTML passage
                    var parser = HTMLParser(html: divRecentHeard, error: &err)
                    var recentHeardContent   = parser.body
                    
                    var imageURL = String()
                    var title = String()
                    var singer = String()
                    
                    //get first item
                    var mostRecentSong = getFirstSong_Image(recentHeardContent)
                    songs.append(mostRecentSong)
                    
                    // Get next 4 items
                    var next4Songs = getNext4Songs(recentHeardContent)
                    for song in next4Songs {
                        songs.append(song)
                    }
                }
            }
        } else {
            println("Error: \(myURLString) doesn't seem to be a valid URL")
        }
        if songs.count != 0{
            self.appDelegate.loadedSongHeaders = NSMutableArray(array: songs)
        }
    }
    
    // This function take in articleInfo html (in div), parse and return article URL and title
    func getArticleTitle_URL(articleInfo: HTMLNode?) -> (article_header: String, article_url: String) {
        var article_url = String()
        var article_header = String()
        var err : NSError?
        if let inputNodes = articleInfo?.xpath("//h2[@class='article-header']") {
            for node in inputNodes {
                var eachArticle = node.rawContents
                // parse the h2 tag content
                var parserArticle = HTMLParser(html: eachArticle, error: &err)
                var articleBody   = parserArticle.body
                if let inputArticle = articleBody?.findChildTags("a") {
                    for node in inputArticle {
                        article_header = node.contents //article header
                        article_url = node.getAttributeNamed("href") //article href
                        article_url = "http://krlx.org/"+article_url
                    }
                }
            }
        }
        return (article_header,article_url)
    }
    
    // This function take in articleInfo html (in div), parse and return article author
    func getArticleAuthor(articleInfo: HTMLNode?) -> String {
        var author = String()
        var err : NSError?
        if let inputNodes = articleInfo?.xpath("//dl[@class='article-info']/dd") {
            for node in inputNodes {
                author = node.contents //author
            }
        }
        return author
    }
    
    // This function take in articleInfo html (in div), parse and return Date of publish
    func getArticleDate(articleInfo: HTMLNode?) -> String {
        var datetime = String()
        var err : NSError?
        if let inputNodes = articleInfo?.xpath("//aside/time") {
            for node in inputNodes {
                datetime = node.getAttributeNamed("datetime") //date of publish
                
            }
        }
        return datetime
    }
    
    // This function take in Recently Heard Songs html (in div), parse and return first item (most recent)
    func getFirstSong_Image(recentHeardContent: HTMLNode?)-> SongHeader{
        var imageURL = String()
        var title = String()
        var singer = String()
        // Get first item title and artist
        // 2 cases with different HTML format:
        // With real image, there is a hyper link attached to artist name
        if let inputNodes = recentHeardContent?.xpath("//div[@id='info']/p/a") {
            title = inputNodes[0].contents //first para is title, second para is artist
            singer = inputNodes[1].contents
        }//Without real picture, no hyper link
        else if let inputNodes = recentHeardContent?.xpath("//div[@id='info']/p") {
            title = inputNodes[0].contents
            singer = inputNodes[1].contents
        }
        
        // Get image of first item
        if let imageTag = recentHeardContent?.findChildTags("img") {
            for node in imageTag {
                imageURL = node.getAttributeNamed("src")//image url is in src tag
            }
        }
        let song = SongHeader(titleString: title, singerString: singer,urlString: imageURL)
        return song
    }
    
    // This function take in Recently Heard Songs html (in div), parse and return next 4 items in array
    func getNext4Songs(recentHeardContent: HTMLNode?)-> [SongHeader] {
        var title = String()
        var singer = String()
        var next4Songs = [SongHeader]()
        // the next 4 songs are in paragraph format (but different from the first item that is is not in "info" div
        if let otherRecentlyHeard = recentHeardContent?.xpath("//p[not(ancestor::div[@id='info'])]") {
            for node in otherRecentlyHeard {
                //manually format tricky html string
                var titleNsinger = (node.rawContents.componentsSeparatedByString("<b>"))[1]
                title = (titleNsinger.componentsSeparatedByString("</b> - "))[0]
                singer = (titleNsinger.componentsSeparatedByString("</b> - "))[1].componentsSeparatedByString("</p>")[0]
                let song = SongHeader(titleString: title, singerString: singer)
                next4Songs.append(song)
            }
        }
        return next4Songs
    }
}
