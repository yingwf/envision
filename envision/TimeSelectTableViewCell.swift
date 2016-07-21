//
//  TimeSelectTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class TimeSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var selectTime: UILabel!
    @IBOutlet weak var selectAddress: UILabel!
    @IBOutlet weak var selectPeople: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectButton.layer.cornerRadius = 10
        selectButton.layer.masksToBounds = true
        
        let sepView = UIView(frame: CGRect(x: 16, y: 65.5, width: self.contentView.frame.width - 32, height: 0.5))
        sepView.backgroundColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
        self.contentView.addSubview(sepView)
        
        self.selectButton.setTitle("已满", forState: .Disabled)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
