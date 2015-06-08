//  ScheduleTableViewCell.swift
//  KRLX
//
//  Defines all aspects of shedule view
//  Created by Josie Bealle, Phuong Dinh, Maraki Ketema, Naomi Yamamoto on April 15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
////

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var start: UILabel!    
    @IBOutlet weak var DJ: UILabel!
    @IBOutlet weak var date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}