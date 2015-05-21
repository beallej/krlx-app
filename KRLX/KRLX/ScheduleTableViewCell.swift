//
//  ScheduleTableViewCell.swift
//
//  Created by Josie and Phuong Dinh on April 15.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    //@IBOutlet weak var DJ:UILabel!
    
    @IBOutlet weak var start: UILabel!
    
    //@IBOutlet weak var end: UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}