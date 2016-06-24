//
//  PositionTypeTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/5/30.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class PositionTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var smallIcon: UIImageView!
    @IBOutlet weak var bigIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var introduction: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bigIcon.layer.cornerRadius = 30
        bigIcon.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
