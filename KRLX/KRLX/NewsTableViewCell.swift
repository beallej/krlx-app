//
//  NewsTableViewCell.swift
//
//  Created by Josie and Phuong Dinh on April 15.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView:UIImageView!
    @IBOutlet weak var postTitleLabel:UILabel!
    @IBOutlet weak var authorLabel:UILabel!

    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.authorImageView.image = UIImage(named: "black")
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
