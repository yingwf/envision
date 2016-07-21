//
//  ApplyStatusTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/27.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class ApplyStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var hint2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bgView.layer.cornerRadius = 5
        self.bgView.layer.masksToBounds = true

    }
    
    func setHide(){
        self.hintLabel.hidden = true
        self.emailLabel.hidden = true
        self.hint2Label.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 34
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 54
        self.contentView.frame = contentFrame
    }
    
    func setApplied(){
        self.hintLabel.hidden = false
        self.emailLabel.hidden = false
        self.hint2Label.hidden = false
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
