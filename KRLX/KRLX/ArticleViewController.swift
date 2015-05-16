//
//  ArticleViewController.swift
//  KRLX
//
//  Created by Josie Bealle on 07/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//



class ArticleViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var subtitle: UITextView!
    
    @IBOutlet weak var content: UITextView!
    
    
    var articleHeader : ArticleHeader!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.articleHeader.getTitle()
        let dt = self.articleHeader.getDate()

        let (day, month, year, longMonth) = (dt[0], dt[1], dt[2], dt[3])
        self.dayLabel.text = day
        self.monthLabel.text = month
        
        //real subtitles actually have more than this...
        self.subtitle.text = "Written by "+self.articleHeader.getAuthor()+"\n"+day+" "+longMonth+" "+year
        
        
        //Because scraping takes and converting html into text takes forever too

        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            
            //Get content
            let articleContentScraped = self.scrape()
            //Put content into textbox
            var attrStr = NSAttributedString(
                data: articleContentScraped.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil,
                error: nil)
            
            dispatch_async(dispatch_get_main_queue()) {
               
                //Get rid of the title in the content and "next" hyperlink at end
                var articleArr = split(attrStr!.string) {$0 == "\n"}
                let repeatedTitleSize: Int = count(articleArr[0])
                let nextLinkSize : Int = count(articleArr[count(articleArr)-1])
                let range : NSRange = NSMakeRange(repeatedTitleSize, attrStr!.length-repeatedTitleSize-nextLinkSize)
                let finalStr = attrStr!.attributedSubstringFromRange(range)
                
                //set content
                self.content.attributedText = finalStr
                self.content.font = UIFont(name: "Avenir Next", size: 14.0)
            }
        }       
                
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
