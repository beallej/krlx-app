//
//  NewsTableViewCell.swift
//  KRLX
//
//  Define each table view cell
//  Created by Josie Bealle, Phuong Dinh, Maraki Ketema, Naomi Yamamoto on April 15.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//


import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateBkgd :UIImageView!
    @IBOutlet weak var postTitleLabel:UILabel!
    @IBOutlet weak var authorLabel:UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Sets black background behind date
        self.dateBkgd.image = UIImage(named: "black")
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
