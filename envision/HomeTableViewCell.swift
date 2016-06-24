//
//  HomeTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/5/29.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var more: UIView!
    
    @IBOutlet weak var aboutImage: UIImageView!
    @IBOutlet weak var aboutText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width = UIScreen.mainScreen().bounds.width
        let seperateView = UIView(frame: CGRect(x: 0, y: 54, width: width, height: 0.5))
        seperateView.backgroundColor = UIColor(red: 0xf7/255, green: 0xf7/255, blue: 0xf7/255, alpha: 1)
        self.contentView.addSubview(seperateView)
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
