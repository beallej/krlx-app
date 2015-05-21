//
//  ArticleViewController.swift
//  KRLX
//
//  Created by Josie Bealle and Phuong Dinh on 07/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//


import Social
import UIKit
import WebKit

class ArticleViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var subtitle: UITextView!
    
    
    @IBOutlet weak var content: UIWebView!
    
    var articleHeader : ArticleHeader!
    var activityIndicator : UIActivityIndicatorView!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set webview delegate
        self.content.delegate = self
        
        //adds spinner to show activity while getting content
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.navigationItem.titleView = self.activityIndicator
        activityIndicator.startAnimating()

        
        //add basic info
        self.titleLabel.text = self.articleHeader.getTitle()
        let dt = self.articleHeader.getDate()
        let (day, month, year, longMonth) = (dt[0], dt[1], dt[2], dt[3])
        self.dayLabel.text = day
        self.monthLabel.text = month
        self.subtitle.text = "Written by "+self.articleHeader.getAuthor()+"\n"+day+" "+longMonth+" "+year
        
        
        //Because scraping takes and converting html into text takes forever too
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            
            //Get content -- check to see if we already loaded it
            if let newStr = self.articleHeader.getContent(){
                self.content.loadHTMLString(newStr, baseURL: NSURL(string: self.articleHeader.getURL()))
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
            else {
                var articleContentScraped = self.scrape()
                articleContentScraped = ((articleContentScraped.componentsSeparatedByString("</h1>"))[1].componentsSeparatedByString("<ul class=\"pager pagenav\">"))[0]
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        //Put the pieces of the giant HTML string together
                        let htmlStrings = self.openFile("htmlString", fileExtension: "txt")!.componentsSeparatedByString("\n")
                        let finalHTMLString = htmlStrings[0]+self.articleHeader.getURL()+htmlStrings[1]+articleContentScraped+htmlStrings[2]
                            
                        self.articleHeader.content = finalHTMLString
                            
                        
                        //load content, dismiss activity indicator
                        self.content.loadHTMLString(finalHTMLString, baseURL: NSURL(string: self.articleHeader.getURL()))
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.removeFromSuperview()
                    }
                }
        }
        
    }
    
// -------------------WHY WONT IT ZOOM OR STAY ZOOMED OR LOCK HOROZONTAL SCROLL I HATE IT----------------------
//    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        self.zoomToFit()
//        let v = content.scrollView.center.x
//        
//    }
    
// -------------------I HAVE TRIED ALL OF THESE TO NO AVAIL----------------------
//    func zoomToFit(){
//        var scroll = self.content.scrollView
//        var ctr = self.view.frame.size.width/2.0
//        scroll.setZoomScale(1.17, animated: true)
//        scroll.center.x = ctr
//        let zoom = (self.content.bounds.size.width+50)/scroll.contentSize.width
//        let diff = (self.content.bounds.size.width*zoom - self.content.bounds.size.width)/2.0
//        
//        let zRect = CGRect(x: self.content.frame.origin.x + 100, y: self.content.frame.origin.y, width: self.content.bounds.size.width-100, height: self.content.frame.height)
//        scroll.zoomToRect(zRect, animated: true)
        //scroll.zoomScale = zoom
       // scroll.setZoomScale(zoom, animated: false)
        //scroll.setContentOffset(CGPointMake(30, 0), animated: false)
// ---------------------------------------------------------------------------


        
    //opens a file
    func openFile (fileName: String, fileExtension: String, utf8: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileExtension)
        var error: NSError?
        return NSFileManager().fileExistsAtPath(filePath!) ? String(contentsOfFile: filePath!, encoding: utf8, error: &error)! : nil
    }
    
    
    //does scraping for an article
    func scrape() -> String{
        let myURLString = self.articleHeader.getURL()
        var article_content = String()
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error {
                println("Error : \(error)")
            } else {
                let html = myHTMLString
                var err : NSError?
                var parser = HTMLParser(html: html!, error: &err)
                if err != nil {
                    //println(err)
                    exit(1)
                }
                var allArticle = parser.body
                if let inputAllArticleNodes = allArticle?.xpath("//div[@class='gk-article']") {
                    for node in inputAllArticleNodes {
                        article_content = node.rawContents
                        
                    }
                }
                else {
                    //println("Error: \(myURLString) doesn't seem to be a valid URL")
                }
            }
        }
        return String(article_content)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
