//
//  NewsTableViewController.swift
//  KRLX
//
//  Created by Josie and Phuong Dinh on April 15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
////

import UIKit
import Social

class NewsTableViewController: UITableViewController, PlayPause {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var spinnyWidget: UIActivityIndicatorView!
    
    var buttonPlay: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var buttonPause: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate    
    
    override func viewDidLoad() {
        
        //Set Play/Pause button in navigation bar
        self.appDelegate.setUpPlayPause(self)
        
        super.viewDidLoad()
        
        //Connect to menu
        self.appDelegate.setUpSWRevealVC(self, menuButton: self.menuButton)
        
        self.loadArticles()


    }
    
    //Loads article info from KRLX website
    func loadArticles(){
        
        //because scraping is sloooowwww, we use the magic of asynchronization!
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            
            let scraper = ScrapeAssistant()
            scraper.scrapeArticleInfo()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.spinnyWidget.stopAnimating()
                self.tableView.reloadData()
                
                
                //No articles found
                if (self.appDelegate.loadedArticleHeaders.count == 0){
                    var alert = UIAlertController(title: "Whoops!", message: "Internet problems, try again later", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return appDelegate.loadedArticleHeaders.count
    }

    //populate table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell
        let article = appDelegate.loadedArticleHeaders[indexPath.row] as! ArticleHeader
        cell.postTitleLabel.text = article.getTitle()
        cell.authorLabel.text = article.getAuthor()
        cell.dayLabel.text = article.getDate()[0]
        cell.monthLabel.text = article.getDate()[1]

        
         return cell
    }

    //When user clicks on an article to view, we load that article
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let articleStoryboard = UIStoryboard(name: "Article", bundle: nil)
        var articleVC = articleStoryboard.instantiateViewControllerWithIdentifier("articleViewController") as! ArticleViewController
        articleVC.articleHeader = appDelegate.loadedArticleHeaders[indexPath.row] as! ArticleHeader
       
        self.navigationController?.pushViewController(articleVC, animated: true)
    }
    
    //Toggles play pause
    @IBAction func musicButtonClicked(sender: AnyObject) {
        self.appDelegate.musicButtonClicked(self)
    }


    
}


