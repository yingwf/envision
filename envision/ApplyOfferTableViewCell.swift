//
//  ApplyOfferTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/27.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class ApplyOfferTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.cornerRadius = 5
        self.bgView.layer.masksToBounds = true
        
    }
    
    func setHide(){
        self.title.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 34
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 54
        self.contentView.frame = contentFrame
    }
    
    func setHaveSended(){
        self.title.text = "已通过面试，请前往邮箱查收offer"
        self.title.hidden = false
    }


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
