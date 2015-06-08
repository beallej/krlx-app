//
//  ScheduleViewController.swift
//  KRLX
//
//  This file handles the schedule view. The name and DJ associated with the current show, and the next upcoming 60 shows are displayed on this view. 
//  Created by Josie Bealle, Phuong Dinh, Maraki Ketema, Naomi Yamamoto
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, DataObserver , PlayPause, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    
    @IBOutlet weak var spinnyWidget: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    var show_arrays = [ShowHeader]()
    var cellIdentifier = "showCell"

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentDJLabel: UILabel!
    @IBOutlet weak var currentShowLabel: UILabel!
    let tap = UITapGestureRecognizer()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var buttonPlay: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var buttonPause: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var calendarAssistant = GoogleAPIPull()
    var filteredShows = [ShowHeader]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding play/pause button in navigation bar
        appDelegate.setUpPlayPause(self)
        
        //Pulls Shows from Calendar
        self.calendarAssistant.pullKRLXGoogleCal(self)
        
        //Connect to menu
        self.appDelegate.setUpSWRevealVC(self, menuButton: self.menuButton)

        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        self.setUpSearchBar()
        // initialise filtered show table to all shows except from the currently showing
        self.filteredShows = NSArray(array: self.appDelegate.loadedShowHeaders) as! [ShowHeader]
        self.filteredShows.removeAtIndex(0)
        
        //clear placeholder time label
        self.currentTimeLabel.text = ""
        
        //Display previously loaded first show
        if appDelegate.loadedShowHeaders.count != 0{
            self.setFirstShow()
        }
        
        // Hide empty cells
        self.tableView.tableFooterView = UIView()

    }
    
    
    override func viewWillAppear(animated: Bool) {
        appDelegate.subscribe(self)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        appDelegate.unssubscribe(self)
    }
    
    
    func setUpSearchBar(){
        self.searchBar.delegate = self
        
        //Makes search keyboard disappear when you touch tableview
        tap.addTarget(self, action: "didTapOnTableView:")
        self.tableView.addGestureRecognizer(tap)
        self.tableView.userInteractionEnabled = true
        self.tableView.addGestureRecognizer(tap)
        
        //Change the font color in the search bar
        var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()

    }
    
    
    
    //Pulls show data for app
    func notify() {
        self.calendarAssistant.pullKRLXGoogleCal(self)
    }
    
    
    
    
    //Upates the view with new data
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
        
        cell.title.text = show.getTitle()
        cell.DJ.text = show.getDJ()
        
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
    
    
    //Toggles play/pause
    @IBAction func musicButtonClicked(sender: AnyObject) {
        appDelegate.musicButtonClicked(self)
    }

    
    
    //This function read the text from search bar and decide whether to reload the data
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var showArrayfull = NSArray(array: self.appDelegate.loadedShowHeaders) as! [ShowHeader]
        var showArrayExceptFirst = NSArray(array: self.appDelegate.loadedShowHeaders) as! [ShowHeader]
        showArrayExceptFirst.removeAtIndex(0)

        // If searchText is empty, return all show (except currently shown)
        // Else, return show with stringMatch only (including current show)
        self.filteredShows = searchText.isEmpty ? showArrayExceptFirst : showArrayfull.filter({(show: ShowHeader) -> Bool in
            
            // stringMatch = true if found a show with either title or DJ
            // that has word start with the user' entered string
            // e.g User enter "Sn" then shows like "Snack Time" will be true but "No Reasons" won't
            var stringMatch = self.searchShowInArray(show, searchText: searchText)
            
            return  stringMatch
        })

        self.tableView.reloadData()
    }
    
    
    //hide keyboard when not in designated searchbar or table :D
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    //hides keybord when search button clicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        self.searchBar.resignFirstResponder()
    }
    
    
    //Makes keyboard disappear when you touch the tableview, because you're done searching
    func didTapOnTableView(recognizer: UIGestureRecognizer) {
        self.searchBar.resignFirstResponder()
    }

    
    
    //This function search
    func searchShowInArray(show: ShowHeader, searchText: String) -> Bool {
        var wholeStringMatch: Bool = false
        // In the entered search text, check if word by word is matched
        for enteredWord in searchText.lowercaseString.componentsSeparatedByString(" ") {
                var oneWordStringMatch = false
                // Search by Show Names
                for word in show.getTitle().lowercaseString.componentsSeparatedByString(" "){
                    // if word starts with entered words or entered word is empty (space), match = true
                    if word.hasPrefix(enteredWord) || enteredWord.isEmpty {
                        oneWordStringMatch = true
                    }
                }
                // Search by DJ
                for word in show.getDJ().lowercaseString.componentsSeparatedByString(" "){
                    if word.hasPrefix(enteredWord) || enteredWord.isEmpty{
                        oneWordStringMatch = true
                    }
                }
                
                // Only accept string if all each individual words are in either title or DJ
                // e.g: If user enter "Ibrahim Show", this will match to "Ibrahim's Show" but not "Phuong's Show"
                if oneWordStringMatch == false {
                    wholeStringMatch = false
                } else {
                    wholeStringMatch = true
                }
        }
        
        return wholeStringMatch
    }

}
