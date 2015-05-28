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
    
    @IBOutlet weak var button: UIButton!
    
    
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
        
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()

        
        //add basic info
        self.titleLabel.text = self.articleHeader.getTitle()
        let dt = self.articleHeader.getDate()
        let (day, month, year, longMonth) = (dt[0], dt[1], dt[2], dt[3])
        self.dayLabel.text = day
        self.monthLabel.text = month
        self.subtitle.text = "Written by "+self.articleHeader.getAuthor()+"\n"+day+" "+longMonth+" "+year
        
        ///////////////Testing Purpose/////////////
        //let button : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        //button.backgroundColor = UIColor.blackColor()
        //self.button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        //self.button.setTitle("Share", forState: UIControlState.Normal)
        //self.button.titleLabel!.adjustsFontSizeToFitWidth = true
        //self.button.titleLabel!.font =  UIFont(name: "Avenir Next Regular", size: 8)
        //self.button = button
        
        //------------------------------------
        //test  spinning image
        
        
        //Display an adorable gif while loading <3
        var urlSpin = NSURL(string:"http://www.blackbox.sa.com/app/webroot/img/loading.gif")
        var req = NSURLRequest(URL:urlSpin!)
        self.content.loadRequest(req)
        //self.content.loadHTMLString("<!DOCTYPE html><html><head></head><body><div><font size='30pt'>Loading... Please wait! or a spinner</font></div></body></html>", baseURL: NSURL(string: self.articleHeader.getURL()))
        
        //-------------------------------------
        
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
                
                //self.scrape()
                articleContentScraped = ((articleContentScraped.componentsSeparatedByString("</h1>"))[1].componentsSeparatedByString("<ul class=\"pager pagenav\">"))[0] //eliminate the title and the next navigation
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        //Put the pieces of the giant HTML string together
                        let htmlStrings = self.openFile("htmlString", fileExtension: "txt")!.componentsSeparatedByString("\n")
                        var finalHTMLString = htmlStrings[0]+self.articleHeader.getURL()+htmlStrings[1]+articleContentScraped+htmlStrings[2]
                        finalHTMLString = finalHTMLString.stringByReplacingOccurrencesOfString("style=\"font-size: 13.0pt; mso-bidi-font-size: 12.0pt;\"", withString:"") // Deal with span html style
                        
                        //load content, dismiss activity indicator
                        self.content.loadHTMLString(finalHTMLString, baseURL: NSURL(string: self.articleHeader.getURL()))
                        
                        //Put content into the class (no need to load next time)
                        self.articleHeader.content = finalHTMLString
                        
                        self.activityIndicator.stopAnimating()
                    }
                }
        }
        
    }
    

        
    //opens a file
    func openFile (fileName: String, fileExtension: String, utf8: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileExtension)
        var error: NSError?
        return NSFileManager().fileExistsAtPath(filePath!) ? String(contentsOfFile: filePath!, encoding: utf8, error: &error)! : nil
    }
    
    
    
    //////////Testing function to create a share button in article itself/////////////////
    /*
    func buttonClicked(sender: UIButton!){
        let threeActionsMainAppController = storyboard?.instantiateViewControllerWithIdentifier("socialMediaView") as! SocialMediaController
        
        presentViewController(threeActionsMainAppController, animated: true, completion: nil)
        
    }
    */
    
    
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
    
    //////////////////////////////////////////////////////////////////////////////////
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
