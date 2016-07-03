//
//  ApplyFinalTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/27.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class ApplyFinalTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.cornerRadius = 5
        self.bgView.layer.masksToBounds = true
        
        let width = self.bgView.frame.width
        let sepView = UIView(frame: CGRect(x: 28, y: 54, width: width - 28, height: 0.5))
        sepView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.1)
        self.bgView.addSubview(sepView)
        
        let sepBView = UIView(frame: CGRect(x: 28, y: 255, width: width - 28, height: 0.5))
        sepBView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.1)
        self.bgView.addSubview(sepBView)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
