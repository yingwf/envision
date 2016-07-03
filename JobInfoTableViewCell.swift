//
//  JobInfoTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/30.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class JobInfoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width = UIScreen.mainScreen().bounds.width
        let sepView = UIView(frame: CGRect(x: 0, y: 44, width: width, height: 0.5))
        sepView.backgroundColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
        self.contentView.addSubview(sepView)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
