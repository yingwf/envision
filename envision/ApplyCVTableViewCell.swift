//
//  ApplyCVTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/27.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class ApplyCVTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.cornerRadius = 5
        self.bgView.layer.masksToBounds = true
        
        self.selectButton.layer.cornerRadius = 5
        self.selectButton.layer.masksToBounds = true
        
    }
    
    func setHide(){
        self.titleLabel.hidden = true
        self.timeLabel.hidden = true
        self.addressLabel.hidden = true
        self.selectButton.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 34
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 54
        self.contentView.frame = contentFrame
    }
    
    func setCvProcessing(){
        self.titleLabel.text = "简历筛选中"
        self.titleLabel.hidden = false
        self.timeLabel.hidden = true
        self.addressLabel.hidden = true
        self.selectButton.hidden = true

        var viewFrame = self.bgView.frame
        viewFrame.size.height = 54
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 74
        self.contentView.frame = contentFrame
        
    }
    
    func setCvNotPass(){
        self.titleLabel.text = "很遗憾，你的简历筛选未通过"
        self.titleLabel.hidden = false
        self.timeLabel.hidden = true
        self.addressLabel.hidden = true
        self.selectButton.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 54
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 74
        self.contentView.frame = contentFrame
        
    }
    
    func setCvGiveup(){
        self.titleLabel.text = "你已选择放弃面试"
        self.titleLabel.hidden = false
        self.timeLabel.hidden = true
        self.addressLabel.hidden = true
        self.selectButton.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 54
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 74
        self.contentView.frame = contentFrame
        
    }
    
    func setCvPass(){
        self.titleLabel.text = "简历筛选已通过，请等待面试安排"
        self.titleLabel.hidden = false
        self.timeLabel.hidden = true
        self.addressLabel.hidden = true
        self.selectButton.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 54
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 74
        self.contentView.frame = contentFrame
        
    }
    
    func setSelectTime(){
        self.titleLabel.text = "筛选已通过，请选择面试时间。"
        self.titleLabel.hidden = false
        self.timeLabel.hidden = true
        self.addressLabel.hidden = true
        self.selectButton.hidden = false
    }
    
    func setTimeSelected(interviewInfo: InterviewInfo){
        self.titleLabel.text = "面试安排如下，请提前10分钟到场。"
        self.titleLabel.hidden = false
        self.timeLabel.hidden = false
        self.addressLabel.hidden = false
        self.selectButton.hidden = true
        self.timeLabel.text = interviewInfo.getInterViewTime()
        self.addressLabel.text = "地点：\(interviewInfo.location!)"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
