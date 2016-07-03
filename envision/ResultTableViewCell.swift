//
//  ResultTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
        
        let sepView1 = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
        sepView1.backgroundColor = UIColor(red: 0xe7/255, green: 0xe7/255, blue: 0xe7/255, alpha: 1)
        self.contentView.addSubview(sepView1)
        
        let sepView2 = UIView(frame: CGRect(x: 0, y: 64.5, width: width, height: 0.5))
        sepView2.backgroundColor = UIColor(red: 0xe7/255, green: 0xe7/255, blue: 0xe7/255, alpha: 1)
        self.contentView.addSubview(sepView2)
        
        let sepView3 = UIView(frame: CGRect(x: 0, y: 129.5, width: width, height: 0.5))
        sepView3.backgroundColor = UIColor(red: 0xe7/255, green: 0xe7/255, blue: 0xe7/255, alpha: 1)
        self.contentView.addSubview(sepView3)
        
        let sepView4 = UIView(frame: CGRect(x: width/2, y: 0, width: 0.5, height: 130))
        sepView4.backgroundColor = UIColor(red: 0xe7/255, green: 0xe7/255, blue: 0xe7/255, alpha: 1)
        self.contentView.addSubview(sepView4)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
