//
//  NewsTableViewController.swift
//
//
//  Created by Josie and Phuong Dinh on April 15.
//

import UIKit
import Social

class NewsTableViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var spinnyWidget: UIActivityIndicatorView!


    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        //because scraping is sloooowwww
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            
            let scraper = ScrapeAssistant()
            let articles = scraper.scrapeArticleInfo()
            if articles.count != 0{
                //insert new articles at the top
                sharedData.loadedArticleHeaders.insertObjects(articles, atIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, articles.count)))
              
                

            }
            dispatch_async(dispatch_get_main_queue()) {
                self.spinnyWidget.stopAnimating()
                self.tableView.reloadData()
                
                if (sharedData.loadedArticleHeaders.count == 0){
                    var alert = UIAlertController(title: "Whoops!", message: "Internet problems, try again later", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        }



        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        return sharedData.loadedArticleHeaders.count
        //return articles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell
        let article = sharedData.loadedArticleHeaders[indexPath.row] as! ArticleHeader
        cell.postTitleLabel.text = article.getTitle()
        cell.authorLabel.text = article.getAuthor()
        cell.dayLabel.text = article.getDate()[0]
        cell.monthLabel.text = article.getDate()[1]

        
         return cell
    }

 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let articleStoryboard = UIStoryboard(name: "Article", bundle: nil)

        var articleVC = articleStoryboard.instantiateViewControllerWithIdentifier("articleViewController") as! ArticleViewController
        articleVC.articleHeader = sharedData.loadedArticleHeaders[indexPath.row] as! ArticleHeader
       
        self.navigationController?.pushViewController(articleVC, animated: true)
    }

    
}


