//
//  NewsTableViewController.swift
//
//
//  Created by Josie and Phuong Dinh on April 15.
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

        self.scrape()
     
//        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
//            self.scrape()
//            dispatch_async(dispatch_get_main_queue()) {
//                // 2
//                // This is where you would reload the tableview with all the scraped thingies.
//                print("Done with scrape in NewsTableViewController!")
//            }
//        }
        
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
                let html = myHTMLString
                var err : NSError?
                var parser = HTMLParser(html: html!, error: &err)
                if err != nil {
                    println(err)
                    exit(1)
                }
                var allArticle = parser.body
                if let inputAllArticleNodes = allArticle?.xpath("//div[@class='items-leading']/div[@class='items-leading'] | //div[@class='items-leading']/div[@class='leading-0']") {
                        for node in inputAllArticleNodes {
                        var bodyHTML = node.rawContents
                        var parser = HTMLParser(html: bodyHTML, error: &err)
                        var bodyNode   = parser.body
                        var author = String()
                        var article_url = String()
                        var article_header = String()
                        var datetime = String()
                        
                        
                        //Get link and title of the article
                        if let inputNodes = bodyNode?.xpath("//h2[@class='article-header']") {
                            for node in inputNodes {
                                var eachArticle = node.rawContents
                                var parserArticle = HTMLParser(html: eachArticle, error: &err)
                                var articleBody   = parserArticle.body
                                if let inputArticle = articleBody?.findChildTags("a") {
                                    for node in inputArticle {
                                        article_header = node.contents
                                        article_url = node.getAttributeNamed("href")
                                        article_url = "http://krlx.org/"+article_url

                                    }
                                }
                            }
                        }
                        
                        //Get author
                        if let inputNodes = bodyNode?.xpath("//dl[@class='article-info']/dd") {
                            for node in inputNodes {
                                author = node.contents

                            }
                        }
                        
                        if let inputNodes = bodyNode?.xpath("//aside/time") {
                            for node in inputNodes {
                                datetime = node.getAttributeNamed("datetime")

                            }
                        }
                        var article = ArticleHeader(authorString: author, titleString: article_header, dateString: datetime, urlString: article_url)
                        articles.append(article)
                    }
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
        println(articles.count)
        return articles.count
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

    
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let articleStoryboard = UIStoryboard(name: "Article", bundle: nil)

        var articleVC = articleStoryboard.instantiateViewControllerWithIdentifier("articleViewController") as! ArticleViewController
        articleVC.articleHeader = articles[indexPath.row]
       
        self.navigationController?.pushViewController(articleVC, animated: true)
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
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//        let articleVC = storyboard!.instantiateViewControllerWithIdentifier("articleViewController") as! ArticleViewController
//        
//        // Now we do just as we did with the CowViewController in prepareForSegue above.
//        //articleVC.url =
//        
//        self.navigationController?.pushViewController(articleVC, animated: true)
//    }
    
    
    
    
    

}


