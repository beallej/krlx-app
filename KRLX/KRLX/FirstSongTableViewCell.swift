//
//  FirstSongTableViewCell.swift
//  KRLX
//
//  Defines layout for first cell of recently heard
//  Created by Josie Bealle, Phuong Dinh, Maraki Ketema, Naomi Yamamoto on 27/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import UIKit

class FirstSongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumArt: UIImageView!
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
