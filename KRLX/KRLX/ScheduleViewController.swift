//
//  ScheduleViewController.swift
//  KRLXperts
//
//  Created by Phuong Dinh and Josie Bealle.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, DataObserver , UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var spinnyWidget: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    var show_arrays = [ShowHeader]()
    var cellIdentifier = "showCell"

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentDJLabel: UILabel!
    @IBOutlet weak var currentShowLabel: UILabel!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var rightBarButtonItem: UIBarButtonItem!
    var buttonPlay: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var buttonPause: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var calendarAssistant = GoogleAPIPull()
    var filteredShows = [ShowHeader]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Adding play/pause button in navigation bar
        self.setButtons()
        self.addRightNavItemOnView()

        
        //Pulls Shows from Calendar
        self.calendarAssistant.pullKRLXGoogleCal(self)
        
        //Change the font color in the search bar
        //var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        //textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
     
        
        //Connect to menu
        self.appDelegate.setUpSWRevealVC(self, menuButton: self.menuButton)

        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        searchBar.delegate = self
        self.filteredShows = NSArray(array: self.appDelegate.loadedShowHeaders) as! [ShowHeader]
        self.filteredShows.removeAtIndex(0)
        //clear placeholder time label
        self.currentTimeLabel.text = ""
        
        //Display previously loaded first show
        if appDelegate.loadedShowHeaders.count != 0{
            self.setFirstShow()

        }

        
        
        

    }
    override func viewWillAppear(animated: Bool) {
        appDelegate.subscribe(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        appDelegate.unssubscribe(self)
    }
    
    func notify() {
        self.calendarAssistant.pullKRLXGoogleCal(self)
    }
    
    func updateView(){
        //UI updates must be in main queue, else there is a delay :(
        dispatch_async(dispatch_get_main_queue()) {
            if (self.appDelegate.loadedShowHeaders.count == 0){
                self.currentShowLabel.text = "Sorry! Internet Problems"
            }
            else{
                self.setFirstShow()
                self.tableView.reloadData()
            }
            if self.spinnyWidget.isAnimating(){
                self.spinnyWidget.stopAnimating()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.filteredShows.count
//        if tableView == self.searchDisplayController!.searchResultsTableView {
//            return self.filteredShows.count - 1
//        } else {
//            return self.appDelegate.loadedShowHeaders.count - 1
//        }
    }
    
    
    //The current show is not in tableview, it is pinned to top in a separate view
    func setFirstShow(){
        let show = appDelegate.loadedShowHeaders[0] as! ShowHeader
        self.currentShowLabel.text = show.getTitle()
        self.currentDJLabel.text = show.getDJ()
        let finalTimeString = show.getStartTime() + " - " + show.getEndTime()
        self.currentTimeLabel.text = finalTimeString
    }
    
    //populates table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var show: ShowHeader
        let cell = tableView.dequeueReusableCellWithIdentifier("showCell", forIndexPath: indexPath) as! ScheduleTableViewCell
        show = self.filteredShows[indexPath.row]

//        if tableView == self.searchDisplayController!.searchResultsTableView {
//            show = self.filteredShows[indexPath.row]
//        } else {
//            show = self.appDelegate.loadedShowHeaders[indexPath.row + 1] as! ShowHeader
//        }
        
        //offset by 1 because the first show is displayed separately
        cell.title.text = show.getTitle()
        
        
        let finalTimeString = show.getStartTime() + " - " + show.getEndTime()
        cell.start.text = finalTimeString
        cell.date.text = show.getDate()
        
        //The last cell isnt a show, it tells you go to the website
        if (indexPath.row == tableView.numberOfRowsInSection(0) - 1){
            cell.start.text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")

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

    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
            var showArray = NSArray(array: self.appDelegate.loadedShowHeaders) as! [ShowHeader]
            self.filteredShows = showArray.filter({(show: ShowHeader) -> Bool in
            let stringMatch = show.title.rangeOfString(searchText)
            return  (stringMatch != nil)
        })
    }

    

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var showArray = NSArray(array: self.appDelegate.loadedShowHeaders) as! [ShowHeader]
        showArray.removeAtIndex(0)
        self.filteredShows = searchText.isEmpty ? showArray : showArray.filter({(show: ShowHeader) -> Bool in
            let stringMatch = show.title.rangeOfString(searchText)
            return  (stringMatch != nil)
        })
        
        tableView.reloadData()
    }
}
