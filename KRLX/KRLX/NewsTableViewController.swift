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

        
        
//        // -------------------IT DOESNT KEEP CONSTRAINTS ON ROTATION :(((----------------------
//
//        //Create Share button
//        let button : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
//        let width : CGFloat = 50
//        let height : CGFloat = 24
//        let top = cell.dateBkgd.frame.maxY - height
//        let left = cell.frame.width - width - 8
//        //button.frame = CGRectMake(left, top, width, height)
//        
//        //flush right
//        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: cell, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -8.0)
//       //align with date
//        NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: cell.dateBkgd, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
//        var frameRect = button.frame
//        frameRect.origin.x = cell.frame.width - width - 8
//        frameRect.origin.y = cell.dateBkgd.frame.maxY - height
//        frameRect.size.width = 50.0
//        frameRect.size.height = 24.0
//        button.frame = frameRect
//  
//            
//        
//        let cellHeight: CGFloat = 44.0
//        button.backgroundColor = UIColor.blackColor()
//        button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//        button.setTitle("Share", forState: UIControlState.Normal)
//        button.titleLabel!.adjustsFontSizeToFitWidth = true
        
        
        /////////////////////////////////////
        ////CHANGE THE FONT LATER!!!!!!!/////
        /////////////////////////////////////
//        button.titleLabel!.font =  UIFont(name: "Avenir Next Regular", size: 8)
//        cell.addSubview(button)
        
        return cell
    }

//    func buttonClicked(sender: UIButton!){
//        let threeActionsMainAppController = storyboard?.instantiateViewControllerWithIdentifier("socialMediaView") as! SocialMediaController
//        
//        presentViewController(threeActionsMainAppController, animated: true, completion: nil)
//        
//    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let articleStoryboard = UIStoryboard(name: "Article", bundle: nil)

        var articleVC = articleStoryboard.instantiateViewControllerWithIdentifier("articleViewController") as! ArticleViewController
        articleVC.articleHeader = sharedData.loadedArticleHeaders[indexPath.row] as! ArticleHeader
       
        self.navigationController?.pushViewController(articleVC, animated: true)
    }
  
/*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "next") {
        }
    }
    
    @IBAction func push(sender : UIButton) {
        performSegueWithIdentifier("next",sender: nil)
    }
    
    //unwind
    @IBAction func exitTo(segue: UIStoryboardSegue) {
        if (segue.identifier == "back") {
        }
        
    }
    */
    
}


