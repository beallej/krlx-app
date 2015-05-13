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
    var articles = [ArticleHeader]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        var article = ArticleHeader(authorString: "Nicki Minaj", titleString: "Beez in the trap", dateString: "2012-01-30")
        articles.append(article)

     
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
            self.scrape()
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
        let article = articles[indexPath.row]
        cell.postTitleLabel.text = article.getTitle()
        cell.authorLabel.text = article.getAuthor()
        cell.dayLabel.text = article.getDate()[0]
        cell.monthLabel.text = article.getDate()[1]


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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let articleVC = storyboard.instantiateViewControllerWithIdentifier("articleViewController") as! ArticleViewController
        
        // Now we do just as we did with the CowViewController in prepareForSegue above.
        articleVC.goatName = self.goatName
        articleVC.delegate = self
        
        self.navigationController?.pushViewController(goatVC, animated: true)
    }
    
    
    
    
    

}

class ArticleHeader {
    var author : String
    var title : String
    var date : [String]
    let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV, DEC"]
    
    init (authorString: String, titleString: String, dateString: String){
        self.author = authorString
        self.title = titleString
        
        var dateArr = split(dateString) {$0 == "-"}
        var monthNum = dateArr[1].toInt()! - 1
        let monthstr = self.months[monthNum]
        
        //[day, MONTH,  year]: ex. ["21", "DEC", "1993"]
        self.date = [dateArr[2], monthstr, dateArr[0]]

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

}
