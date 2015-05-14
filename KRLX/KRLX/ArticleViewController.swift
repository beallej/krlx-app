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
        self.dayLabel.text = dt[0]
        self.monthLabel.text = dt[1]
        //real subtitles actually have more than this... I'm ok with this though :D the date is pretty!
        self.subtitle.text = self.articleHeader.getAuthor()
        
        //Get content
        let articleContentScraped = self.scrape()
        //Put content into textbox
        var attrStr = NSAttributedString(
            data: articleContentScraped.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil,
            error: nil)
        self.content.attributedText = attrStr
        
        //Because scraping takes and converting html into text takes forever too
//        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
//            
//            let articleContentScraped = String(self.scrape())
//            self.content.text = articleContentScraped
//            dispatch_async(dispatch_get_main_queue()) {
//                // 2
//                // This is where you would reload the view with all the scraped info
//                print("Done with async stuff!")
//            }
//        }
        
                
        // Do any additional setup after loading the view.
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
