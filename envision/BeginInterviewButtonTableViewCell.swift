//
//  BeginInterviewButtonTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/24.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class BeginInterviewButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var beginButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        beginButton.layer.cornerRadius = 10
        beginButton.layer.masksToBounds = true
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
