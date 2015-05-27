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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)

        // Do any additional setup after loading the view.
        scraper = ScrapeAssistant()
        self.loadSongs()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        self.loadSongs()
        
    }
    //because containsobj doesnt work
    //will fix later
//    func checkIfInSongList(songs: [SongHeader]){
//        var titleList = [String]()
//        for i in 0...4{
//            let loadedSong = sharedData.loadedSongHeaders.objectAtIndex(i) as! SongHeader
//            titleList.append(loadedSong.getTitle())
//        }
//        var j = 0
//        for song in songs{
//            if !(song.getTitle() in titleList){
//                sharedData.loadedSongHeaders.insertObject(song, atIndex: j)
//            }
//            j+=1
//            
//            
//        }
//        
//    }
    
    func loadSongs(){
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) {
            if !(self.spinnyWidget.isAnimating()) {
                self.spinnyWidget.startAnimating()
            }
            
            let songs = self.scraper.scrapeRecentlyHeard()
            if songs.count != 0{
                //insert new articles at the top
                sharedData.loadedSongHeaders.insertObjects(songs, atIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, songs.count)))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.spinnyWidget.stopAnimating()
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
        return sharedData.loadedSongHeaders.count
        //return articles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        let song = sharedData.loadedSongHeaders[indexPath.row] as! SongHeader
        
        
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
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("otherSong", forIndexPath: indexPath) as! OtherSongTableViewCell
            cell.title.text = song.getTitle()
            cell.artist.text = song.getArtist()
            return cell
        }
        
        
    }
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.row == 0{
                return 63
            }
            else{
                return 44
            }
            
    }

   



}
