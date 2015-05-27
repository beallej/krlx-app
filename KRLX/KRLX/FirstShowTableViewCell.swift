//
//  FirstShowTableViewCell.swift
//  KRLX
//
//  Created by Josie Bealle on 27/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

import UIKit

class FirstShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var title: UILabel!
    //@IBOutlet weak var DJ:UILabel!
    
    @IBOutlet weak var artist: UILabel!
    
    var song : SongHeader!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.text = song.getTitle()
        self.artist.text = song.getArtist()
        
        //if returns nil, this should not be the first song!
        self.albumArt.image = UIImage(contentsOfFile: song.getURL()!)
        
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
