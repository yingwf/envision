//
//  CVTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/7.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class CVTableViewCell: UITableViewCell {

    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
