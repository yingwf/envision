//
//  CVListTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/7/8.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class CVListTableViewCell: UITableViewCell {
    @IBOutlet weak var headImg: UIImageView!

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var school: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headImg.layer.cornerRadius = 22.5
        headImg.layer.masksToBounds = true
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
