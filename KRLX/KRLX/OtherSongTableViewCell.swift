//
//  OtherSongTableViewCell.swift
//  KRLX
//
//  Created by Josie Bealle on 27/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
////

import Foundation
import UIKit

class OtherSongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var artist: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
