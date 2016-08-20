//
//  CenterTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/5/31.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class CenterTableViewCell: UITableViewCell {

    @IBOutlet weak var messageHint: UIView!
    
    @IBOutlet weak var centerImage: UIImageView!
    
    @IBOutlet weak var centerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageHint.layer.masksToBounds = true
        messageHint.layer.cornerRadius = 3
        messageHint.hidden = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
