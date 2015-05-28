//
//  ScheduleViewController.swift
//  KRLXperts
//
//  Created by Phuong Dinh and Josie Bealle.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var spinnyWidget: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    var show_arrays = [ShowHeader]()
    var cellIdentifier = "showCell"

    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentDJLabel: UILabel!
    @IBOutlet weak var currentShowLabel: UILabel!
    
    var refreshTimer : NSTimer!
    var calendarAssistant : GoogleAPIPull!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Change the font color in the search bar
        var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
        
        var app = UIApplication.sharedApplication()
        app.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        //clear placeholder time label
        self.currentTimeLabel.text = ""
        
        //Display previously loaded first show
        if sharedData.loadedShowHeaders.count != 0{
            self.setFirstShow()

        }

        // Pull calendar
        self.calendarAssistant = GoogleAPIPull()
        self.loadCalendar()
        self.spinnyWidget.stopAnimating()
        
        self.setUpTimer()
        

    }
    
    
    func setUpTimer(){
        //refreshes at next half hour
        let timeInt = self.getTimeToRefresh()
        let timeSeconds : NSTimeInterval = Double(timeInt)*60.0
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(timeSeconds, target: self, selector: Selector("refreshCalendar"), userInfo: nil, repeats: false)
    }
    
    //gets time between now and next 30 min mark, so we know when to refresh next
    func getTimeToRefresh() -> Int{
        let now = NSDate()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm"
        var minString = dateFormatter.stringFromDate(now) as String
        let minInt = minString.toInt()!
        
        
        var timeToRefresh : Int
        if minInt <= 30 {
            timeToRefresh = 30 - minInt
        }
        else{
            timeToRefresh = 60 - minInt
        }
        return timeToRefresh
        
        
    }
    func refreshCalendar(){
        self.loadCalendar()
        
        //refreshes every 30 minutes
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1800.00, target: self, selector: Selector("loadCalendar"), userInfo: nil, repeats: true)
        
    }
    func loadCalendar(){
        if let needReload = self.calendarAssistant.pullKRLXGoogleCal(){
            if needReload {
                self.setFirstShow()
                self.tableView.reloadData()
            }
        }
        else{
            if (sharedData.loadedShowHeaders.count == 0){
                self.currentShowLabel.text = "Sorry! Internet Problems"
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
        return sharedData.loadedShowHeaders.count - 1
    }
    
    
    //The current show is not in tableview, it is pinned to top in a separate view
    func setFirstShow(){
        let show = sharedData.loadedShowHeaders[0] as! ShowHeader
        self.currentShowLabel.text = show.getTitle()
        self.currentDJLabel.text = show.getDJ()
        let finalTimeString = show.getStartTime() + " - " + show.getEndTime()
        self.currentTimeLabel.text = finalTimeString
    }
    
    //populates table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showCell", forIndexPath: indexPath) as! ScheduleTableViewCell
        let show = sharedData.loadedShowHeaders[indexPath.row + 1] as! ShowHeader
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


}
