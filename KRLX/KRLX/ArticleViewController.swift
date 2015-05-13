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
        
        //real subtitles actually have more than this...
        self.subtitle.text = self.articleHeader.getAuthor()
        
        
        //Because scraping takes foever
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
            
            self.scrape()
            dispatch_async(dispatch_get_main_queue()) {
                // 2
                // This is where you would reload the view with all the scraped info
                print("Done with async stuff!")
            }
        }
        
                
        // Do any additional setup after loading the view.
    }
    
    

    //does scraping for an article    
    func scrape(){
        print(self.articleHeader.getURL())
        let myURLString = self.articleHeader.getURL()
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error {
                println("Error : \(error)")
            } else {
                let html = myHTMLString
                var err : NSError?
                println("before parse")
                var parser = HTMLParser(html: html!, error: &err)
                println("after parse")
                if err != nil {
                    println(err)
                    exit(1)
                }
                var allArticle = parser.body
                //Do parsing here
                
            }
        }
        else {
        println("Error: \(myURLString) doesn't seem to be a valid URL")
        }
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
