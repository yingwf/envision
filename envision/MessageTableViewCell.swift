//
//  MessageTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/7/12.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var redDot: UIView!
    
    @IBOutlet weak var sendTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.redDot.layer.cornerRadius = 2.5
        self.redDot.layer.masksToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
