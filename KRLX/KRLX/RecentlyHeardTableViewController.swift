//
//  MapViewController.swift
//  SidebarMenu
//
//  Created by KRLXpert, adapted from Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class RecentlyHeardTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var spinnyWidget: UIActivityIndicatorView!
    
    var scraper : ScrapeAssistant!

    var rightBarButtonItem: UIBarButtonItem!
    var buttonPlay: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var buttonPause: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setButtons()
        self.addRightNavItemOnView()
        
        //Connect to menu
        self.appDelegate.setUpSWRevealVC(self, menuButton: self.menuButton)
       
        tableView.tableFooterView = UIView()
        
        
        //pull to refresh power!
        //http://www.andrewcbancroft.com/2015/03/17/basics-of-pull-to-refresh-for-swift-developers/
        self.refreshControl?.tintColor = UIColor.grayColor()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
     
        //Pull songs from server, load into table
        scraper = ScrapeAssistant()
        self.loadSongs()
       
    }
    
    //Pull to refresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.loadSongs()
        
    }
    
        
    //Pull songs from server asynchronously and puts them in table
    func loadSongs(){
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {

            self.scraper.scrapeRecentlyHeard()
      
            dispatch_async(dispatch_get_main_queue()) {
                self.spinnyWidget.stopAnimating()
                self.tableView.reloadData()
                
                
                //This has to be set here, after the tableview has been loaded, as opposed to as within viewDidLoad/willAppear/didAppear (at those points, the tableview has not yet been loaded because we're loading it asynchronously)
                self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
                if (self.refreshControl!.refreshing) {
                    self.refreshControl?.endRefreshing()
                }

            }
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
        return appDelegate.loadedSongHeaders.count
    }
    
    //popoulate table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        let song = appDelegate.loadedSongHeaders[indexPath.row] as! SongHeader
        
        //The one with the album art
        if indexPath.row == 0{
            var cell = tableView.dequeueReusableCellWithIdentifier("firstSong", forIndexPath: indexPath) as! FirstSongTableViewCell
            cell.title.text = song.getTitle()
            cell.artist.text = song.getArtist()
            
            //if returns nil, this should not be the first song!
            if let url = song.getURL(){
                let cellImage = UIImage(data: NSData(contentsOfURL: NSURL(string: url)!)!)
                    cell.albumArt.image = cellImage
            }
            
            return cell
        }
            
        //Other songs
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("otherSong", forIndexPath: indexPath) as! OtherSongTableViewCell
            cell.title.text = song.getTitle()
            cell.artist.text = song.getArtist()
            return cell
        }
        
        
    }
    
    //Needed because first cell is bigger to fit the album art
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.row == 0{
                return 100
            }
            else{
                return 50
            }
            
    }

    ///Adding play/pause button
    func addRightNavItemOnView()
    {
        var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isPlaying {
            self.rightBarButtonItem = UIBarButtonItem(customView: self.buttonPause)
            
        }else{
            self.rightBarButtonItem = UIBarButtonItem(customView: self.buttonPlay)
        }
        self.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: false)
        
    }
    
    
    @IBAction func musicButtonClicked(sender: AnyObject) {
        if appDelegate.isPlaying {
            self.pauseRadio()
            appDelegate.isPlaying = false
            
        }else{
            self.playRadio()
            appDelegate.isPlaying = true
            
        }
    }
    
    func playRadio(){
        appDelegate.player.play()
        self.rightBarButtonItem = UIBarButtonItem(customView: self.buttonPause)
        self.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: false)
    }
    
    func pauseRadio(){
        appDelegate.player.pause()
        self.rightBarButtonItem = UIBarButtonItem(customView: self.buttonPlay)
        self.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: false)
    }
    
    func setButtons(){
        self.buttonPlay.frame = CGRectMake(0, 0, 40, 40)
        self.buttonPlay.setImage(UIImage(named:"play.png"), forState: UIControlState.Normal)
        self.buttonPlay.addTarget(self, action: "musicButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.buttonPause.frame = CGRectMake(0, 0, 40, 40)
        self.buttonPause.setImage(UIImage(named:"pause.png"), forState: UIControlState.Normal)
        self.buttonPause.addTarget(self, action: "musicButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }


}
