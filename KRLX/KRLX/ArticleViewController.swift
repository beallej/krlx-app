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
import AVFoundation

class ArticleViewController: UIViewController, UIWebViewDelegate, AVAudioPlayerDelegate, UIActionSheetDelegate, PlayPause {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var subtitle: UITextView!
    
    @IBOutlet weak var button: UIButton!
    
    
    @IBOutlet weak var content: UIWebView!
    
    var articleHeader : ArticleHeader!
    var activityIndicator : UIActivityIndicatorView!
    
    var buttonPlay: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var buttonPause: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding play/pause button in navigation bar
        appDelegate.setUpPlayPause(self)
        
        //set webview delegate
        self.content.delegate = self
        
        self.addActivityIndicator()
        self.formatLables()
        self.loadArticle()
        
    }

  
    func addActivityIndicator(){
        //adds spinner to show activity while getting content
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        self.navigationItem.titleView = self.activityIndicator
        
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()

    }
    
    func formatLables(){
        //add basic info
        self.titleLabel.text = self.articleHeader.getTitle()
        let dt = self.articleHeader.getDate()
        let (day, month, year, longMonth) = (dt[0], dt[1], dt[2], dt[3])
        self.dayLabel.text = day
        self.monthLabel.text = month
        self.subtitle.text = "Written by "+self.articleHeader.getAuthor()+"\n"+day+" "+longMonth+" "+year
    }
    func loadArticle(){
        //Display an adorable gif while loading <3
        var urlSpin = NSURL(string:"http://www.blackbox.sa.com/app/webroot/img/loading.gif")
        var req = NSURLRequest(URL:urlSpin!)
        self.content.loadRequest(req)

        //Because scraping takes and converting html into text takes forever too, we use the magical powers of asychronization!
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            
            //Get content -- check to see if we already loaded it
            if let newStr = self.articleHeader.getContent(){
                self.content.loadHTMLString(newStr, baseURL: NSURL(string: self.articleHeader.getURL()))
                self.activityIndicator.stopAnimating()
            }
            else {
                let scraper = ScrapeAssistant()
                var articleContentScraped = scraper.scrapeArticle(self.articleHeader.getURL())
                
                    dispatch_async(dispatch_get_main_queue()) {
                    
                    //load content, dismiss activity indicator
                    let finalHTMLString = self.createHTMLString(articleContentScraped)

                    self.content.loadHTMLString(finalHTMLString, baseURL: NSURL(string: self.articleHeader.getURL()))
                        
                    //Put content into the class (no need to load next time)
                    self.articleHeader.content = finalHTMLString
                    
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    //Put the pieces of the giant HTML string together
    func createHTMLString(articleContentScraped : String) -> String{
        let articleNoTitle = ((articleContentScraped.componentsSeparatedByString("</h1>"))[1].componentsSeparatedByString("<ul class=\"pager pagenav\">"))[0] //eliminate the title and the next navigation

        let htmlStrings = self.appDelegate.openFile("htmlString", fileExtension: "txt")!.componentsSeparatedByString("\n")
        var finalHTMLString = htmlStrings[0]+self.articleHeader.getURL()+htmlStrings[1]+articleNoTitle+htmlStrings[2]
        
        // Deal with span html style
        finalHTMLString = finalHTMLString.stringByReplacingOccurrencesOfString("style=\"font-size: 13.0pt; mso-bidi-font-size: 12.0pt;\"", withString:"")
        return finalHTMLString
    }
    
   
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "next") {
            var newURL = articleHeader.getURL()
            let destinationVC = segue.destinationViewController as! SocialMediaController
            destinationVC.articleURL = newURL
        }
        var newURL = articleHeader.getURL()
        let destinationVC = segue.destinationViewController as! SocialMediaController
        destinationVC.articleURL = newURL
    }
    //unwind
    @IBAction func exitTo(segue: UIStoryboardSegue) {
        if (segue.identifier == "back") {
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func musicButtonClicked(sender: AnyObject) {
        appDelegate.musicButtonClicked(self)
    }
    
    
    
    @IBAction func showShareActionSheet(sender: AnyObject) {
        /*
        var sheet: UIActionSheet = UIActionSheet()
        let title: String = "Share Article"
        sheet.title  = title
        sheet.delegate = self
        sheet.addButtonWithTitle("Cancel")
        sheet.addButtonWithTitle("Facebook")
        sheet.addButtonWithTitle("Twitter")
        
        sheet.cancelButtonIndex = 0
            //sheet.buttonTitleAtIndex(buttonIndex)
        sheet.showInView(self.view)
*/
        var newURL = articleHeader.getURL()
        shareContent(text: newURL)
    }
    
    func shareContent(#text: String?) {
        var itemsToShare = [AnyObject]()
        if let text = text {
            itemsToShare.append(text)
        }
        
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
    }

    
}
