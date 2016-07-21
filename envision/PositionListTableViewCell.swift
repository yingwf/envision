//
//  PositionListTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/5/31.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class PositionListTableViewCell: UITableViewCell {

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var favorImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width = UIScreen.mainScreen().bounds.width
        let sepView = UIView(frame: CGRect(x: 16, y: 72.5, width: width - 16, height: 0.5))
        sepView.backgroundColor = SEPERATORCOLOR
        self.contentView.addSubview(sepView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
