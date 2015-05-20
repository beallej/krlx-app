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

class ArticleViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var subtitle: UITextView!
    
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var uiWebView: UIWebView!
    
    var webView: WKWebView?
    
    var articleHeader : ArticleHeader!
    var activityIndicator : UIActivityIndicatorView!
    
    
//   ------I tried CSS but fail -------------
//    required init(coder aDecoder: NSCoder) {
//        let config = WKWebViewConfiguration()
//        let scriptURL = NSBundle.mainBundle().pathForResource("articleNameStyle", ofType: "js")
//        let scriptContent = String(contentsOfFile:scriptURL!, encoding:NSUTF8StringEncoding, error: nil)
//        let script = WKUserScript(source: scriptContent!, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
//        config.userContentController.addUserScript(script)
//        self.webView = WKWebView(frame: CGRectZero, configuration: config)
//        super.init(coder: aDecoder)
//    }
// -----------------------------------------
    
    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView()
        self.view = self.webView!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adds spinner to show activity while getting content
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.navigationItem.titleView = self.activityIndicator
        activityIndicator.startAnimating()

        
        //-------------UNCOMMENT IF WE ONLY SCRAPE CONENT------------
        
        //        self.titleLabel.text = self.articleHeader.getTitle()
        //        let dt = self.articleHeader.getDate()
        //
        //        let (day, month, year, longMonth) = (dt[0], dt[1], dt[2], dt[3])
        //        self.dayLabel.text = day
        //        self.monthLabel.text = month
        //
        //
        //        //real subtitles actually have more than this...
        //        self.subtitle.text = "Written by "+self.articleHeader.getAuthor()+"\n"+day+" "+longMonth+" "+year
        //-------------------------------------------------------------
        
        
        //Because scraping takes and converting html into text takes forever too
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            
            //Get content
            var articleContentScraped = self.scrape()
            articleContentScraped = ((articleContentScraped.componentsSeparatedByString("</h1>"))[1].componentsSeparatedByString("<ul class=\"pager pagenav\">"))[0]

            
            //Put content into textbox
//            var attrStr = NSAttributedString(
//                data: articleContentScraped.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
//                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//                documentAttributes: nil,
//                error: nil)
//            println("NEWSTRING")
//            println(attrStr)
//            println("NEWSTRING")
            
            dispatch_async(dispatch_get_main_queue()) {
//                
//                //Get rid of the title in the content and "next" hyperlink at end
//                var articleArr = split(attrStr!.string) {$0 == "\n"}
//                let repeatedTitleSize: Int = count(articleArr[0])
//                let nextLinkSize : Int = count(articleArr[count(articleArr)-1])
//                let range : NSRange = NSMakeRange(repeatedTitleSize, attrStr!.length-repeatedTitleSize-nextLinkSize)
//                let finalStr = attrStr!.attributedSubstringFromRange(range)
//                let otherString = finalStr.string
                let otherString = articleContentScraped
                var newStr = "<!DOCTYPE html><html><head><base href=\""+self.articleHeader.getURL()+"\"/><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" /><link rel=\"stylesheet\" href=\"http://krlx.org/media/mod_social_slider/css/style.css\" type=\"text/css\" /><meta name=\"viewport\"><link rel=\"stylesheet\" href=\"http://krlx.org/templates/krlx/css/bootstrap.css\" type=\"text/css\" media=\"screen\" /><link rel=\"stylesheet\" href=\"http://krlx.org/templates/krlx/css/docs.css\" type=\"text/css\" media=\"screen\" /><link rel=\"stylesheet\" href=\"http://krlx.org/templates/krlx/css/bootstrap-responsive.css\" type=\"text/css\" media=\"screen\" /><link rel=\"stylesheet\" href=\"/templates/krlx/css/custom.css\" type=\"text/css\" /><link rel=\"stylesheet\" href=\"/templates/krlx/css/jquery.gcal_flow.css\" type=\"text/css\" /><link rel=\"stylesheet\" href=\"/templates/krlx/css/buttons.css\" type=\"text/css\" media=\"screen\"><link href='http://fonts.googleapis.com/css?family=Oswald:100,300,400,700,900,100italic,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css'><link href='http://fonts.googleapis.com/css?family=Open+Sans:100,300,400,700,900,100italic,300italic,400italic,700italic,900italic' rel='stylesheet' type='text/css'></head><body><div class=\"gk-article\">"+otherString+"</div></body></html>"
                //sorry about the long string. Maybe we can tuck this away on some textfile
                
                self.webView?.loadHTMLString(newStr, baseURL: NSURL(string: self.articleHeader.getURL()))
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
        }
        
    }


    
    
    
    //    //does scraping for an article
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
                    println(err)
                    exit(1)
                }
                var allArticle = parser.body
                if let inputAllArticleNodes = allArticle?.xpath("//div[@class='gk-article']") {
                    for node in inputAllArticleNodes {
                        article_content = node.rawContents
                        println(article_content)
                        
                    }
                }
                else {
                    println("Error: \(myURLString) doesn't seem to be a valid URL")
                }
            }
        }
        return String(article_content)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
