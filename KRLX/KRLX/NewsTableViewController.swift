//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
   
     
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
            
            dispatch_async(dispatch_get_main_queue()) {
                // 2
                // This is where you would reload the tableview with all the scraped thingies.
                print("Done!")
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func scrape(){
        let myURLString = "http://www.krlx.org/"
        
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            
            if let error = error {
                println("Error : \(error)")
            } else {

                //println("HTML : \(myHTMLString)")
                let html = myHTMLString
                var err : NSError?
                println("before parse")
                var parser     = HTMLParser(html: html!, error: &err)
                println("after parse")
                if err != nil {
                    println(err)
                    exit(1)
                }
                
                var bodyNode   = parser.body

                var count = 0
                if let inputNodes = bodyNode?.xpath("//h2[@class='article-header']") {
                    for node in inputNodes {
                        println("hey")
                        var eachArticle = node.rawContents
                        var parserArticle = HTMLParser(html: eachArticle, error: &err)
                        var articleBody   = parserArticle.body
                        if let inputArticle = articleBody?.findChildTags("a") {
                            for node in inputArticle {
                                var article_header = node.contents
                                var article_url = node.getAttributeNamed("href")
                                println(article_header)
                                println(article_url)
                            }
                        }
                        
                        count = count + 1
                    }
                    println(count)
                }
       

            }
        } else {
            println("Error: \(myURLString) doesn't seem to be a valid URL")
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell

        // Configure the cell...
        if indexPath.row == 0 {
            cell.postImageView.image = UIImage(named: "musicBackground1")
            cell.postTitleLabel.text = "• New Music Week 4 •"
            cell.authorLabel.text = "Written by: Mary Reagan Harvey"
            cell.authorImageView.image = UIImage(named:  "dateImage")

//        } else if indexPath.row == 1 {
//            cell.postImageView.image = UIImage(named: "custom-segue-featured-1024")
//            cell.postTitleLabel.text = "This is a promotion"
//            cell.authorLabel.text = "KRLX"
//            cell.authorImageView.image = UIImage(named: "author")
//            
//        } else {
//            cell.postImageView.image = UIImage(named: "webkit-featured")
//            cell.postTitleLabel.text = "This is news article"
//            cell.authorLabel.text = "???"
//            cell.authorImageView.image = UIImage(named: "author")
//            
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

class ArticleHeader {
    var author : String
    var title : String
    var date : NSDate
    
    init (authorString: String, titleString: String, dateString: String){
        self.author = authorString
        self.title = titleString
      
        var dateFormat = NSDateFormatter()
      
        dateFormat.dateFormat = "yyyy-MM-dd"
        var dateFromString = dateFormat.dateFromString(dateString);
        self.date = dateFromString!

    }
}
