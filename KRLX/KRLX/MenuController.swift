//
//  MenuController.swift
//  KRLX
//
//  Created by Simon Ng on 2/2/15.
//  Adapted by Josie Bealle, Phuong Dinh, Maraki Ketema, Naomi Yamamoto on May 2015
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //menu background image
        var imgView:UIImageView = UIImageView(image:UIImage(named: "sideBarPic2"))
        self.tableView.backgroundView = imgView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
