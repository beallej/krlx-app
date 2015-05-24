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
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.pullKRLXGoogleCal()


    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullKRLXGoogleCal() {
        
        //--------------------
        //Need to get current time to put into the API String
        // API also don't return the event at the right time (I wonder if time zone is different!!!)
        //--------------------------
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/cetgrdg2sa8qch41hsegktohv0%40group.calendar.google.com/events?singleEvents=true&orderBy=startTime&timeMin=2015-05-23T10%3A44%3A59Z&timeZone=America%2FChicago&maxResults=100&key=AIzaSyD-Lcm54auLNoxEPqxNYpq2SP4Jcldzq2I")
   
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = url
        request.HTTPMethod = "GET"
        var response: NSURLResponse?
        var error: NSError?
        
   
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var errorJSON: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: errorJSON) as? NSDictionary
            
            if (jsonResult != nil){
                if let allitems_wrapper = jsonResult["items"] as? NSArray{
                    for item in allitems_wrapper {
                        var ShowTitle = item["summary"] as! String
                        var startTime = (item["start"] as! NSDictionary)["dateTime"] as! String
                        var endTime = (item["end"] as! NSDictionary)["dateTime"] as! String
                        var ShowDJ: String
                        if let DJ:String = item["description"] as? String {
                            ShowDJ = DJ
                        }
                        else {
                            ShowDJ = ""
                        }
                        var show = ShowHeader(titleString: ShowTitle, startString: startTime, endString: endTime, DJString: ShowDJ)
                        self.show_arrays.append(show)
                        
                    }
                }
                var newShowList = NSMutableArray(array: self.show_arrays)
                if newShowList != sharedData.loadedShowHeaders{
                    sharedData.loadedShowHeaders = newShowList
                    self.setFirstShow()
                    self.tableView?.reloadData()

                }
                self.spinnyWidget.stopAnimating()
            }
            else
            {
                //Handle ERROR
                //-------NOT DONE---------
            }
        })
    }
    
    //times are formatted super ugly-ly
    func prettifyTimeLabel(time: String) -> String
    {
        var finalTime : String
        //2015-05-21T05:30:00-05:00 --> 05:30:00
        var tm = time.componentsSeparatedByString("T")[1].componentsSeparatedByString("-")[0]
        
        //05:30:00 --> 5:30
        var hour = tm.substringWithRange(Range<String.Index>(start: tm.startIndex, end: advance(tm.endIndex, -6)))
        var minute = tm.substringWithRange(Range<String.Index>(start: advance(tm.startIndex, 2), end: advance(tm.endIndex, -3)))
        var hourNumber = hour.toInt()
        
        //this isn't military time
        if hourNumber > 12 {
            hourNumber = hourNumber! % 12
            finalTime = hourNumber!.description + minute + "pm"
        }
        else{
            finalTime = hourNumber!.description+minute+"am"
        }
        return finalTime
        
    }
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return sharedData.loadedShowHeaders.count - 1
    }
    
    
    //The current show is not in tableview, it is pinned to top in a view
    func setFirstShow(){
        let show = sharedData.loadedShowHeaders[0] as! ShowHeader
        self.currentShowLabel.text = show.getTitle()
        self.currentDJLabel.text = show.getDJ()
        let finalTimeString = self.prettifyTimeLabel(show.getStartTime()) + " - " + self.prettifyTimeLabel(show.getEndTime())
        self.currentTimeLabel.text = finalTimeString
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showCell", forIndexPath: indexPath) as! ScheduleTableViewCell
        let show = sharedData.loadedShowHeaders[indexPath.row + 1] as! ShowHeader
        cell.title.text = show.getTitle()
        let finalTimeString = self.prettifyTimeLabel(show.getStartTime()) + " - " + self.prettifyTimeLabel(show.getEndTime())
        cell.start.text = finalTimeString
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }


}
