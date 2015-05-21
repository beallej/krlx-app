//
//  ScheduleViewController.swift
//  KRLXperts
//
//  Created by Phuong Dinh and Josie Bealle, adapted from Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    
    @IBOutlet weak var tableView: UITableView!
    var show_arrays = [ShowHeader]()
    var cellIdentifier = "showCell"

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

        // Pull calendar
        self.pullKRLXGoogleCal()


    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pullKRLXGoogleCal() {
        let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/o6bu0ms41q99plohvtkdkt9th4%40group.calendar.google.com/events?key=AIzaSyC9CY79m2HwZZGE24UZU_MRppmumYMCOgI") //this is my google event, not KRLX
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = url
        request.HTTPMethod = "GET"
        var response: NSURLResponse?
        var error: NSError?
        
   
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var errorJSON: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: errorJSON) as? NSDictionary
            
            if (jsonResult != nil){
                // No idea how to parse this object as it seems to be a NSDictionary but battling to interact with it.
                if let allitems_wrapper = jsonResult["items"] as? NSArray{
                    for item in allitems_wrapper {
                        var ShowTitle = item["summary"] as! String
                        var startTime = (item["start"] as! NSDictionary)["dateTime"] as! String
                        var endTime = (item["end"] as! NSDictionary)["dateTime"] as! String
//                        println(ShowTitle)
//                        println(startTime)
//                        println(endTime)
//                        println("---------")
                        var show = ShowHeader(titleString: ShowTitle, startString: startTime, endString: endTime, DJString: "UNKNOWN lol")
                        self.show_arrays.append(show)
                        
                    }
                }
                //self.setupViews()
                self.tableView?.reloadData()
            }
            else
            {
                //Handle ERROR
                //-------NOT DONE---------
            }
        })
    }
    

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        println(self.show_arrays.count)
        return self.show_arrays.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("showCell", forIndexPath: indexPath) as! ScheduleTableViewCell
        let show = self.show_arrays[indexPath.row]
        //-------------Not sure why optional value here?????????-------
        cell.title.text = show.getTitle()
        cell.start.text = show.getStartTime()
        //---------------
        println("Print Cell")
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }


}
