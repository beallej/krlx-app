//
//  OtherShowTableViewCell.swift
//  KRLX
//
//  Created by Josie Bealle on 27/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import Foundation
import UIKit

class OtherShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    //@IBOutlet weak var DJ:UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    var song : SongHeader!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.text = song.getTitle()
        self.artist.text = song.getArtist()
        
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
