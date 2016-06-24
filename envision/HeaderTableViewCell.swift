//
//  HeaderTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/5/31.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var dreamerID: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var toLogin: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.headImage.layer.masksToBounds = true
        self.headImage.layer.cornerRadius = 30
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
