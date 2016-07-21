//
//  InterviewTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/21.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class InterviewTableViewCell: UITableViewCell {

    @IBOutlet weak var jobType: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var jobName: UILabel!
    
    @IBOutlet weak var personAmount: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var readcv: UIView!
    
    @IBOutlet weak var interview: UIView!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        jobType.layer.cornerRadius = 15
        jobType.layer.masksToBounds = true
        
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        
        readcv.layer.borderWidth = 0.5
        readcv.layer.borderColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.24).CGColor
        readcv.layer.cornerRadius = 5
        readcv.layer.masksToBounds = true
        
        interview.layer.cornerRadius = 5
        interview.layer.masksToBounds = true
        
        let bgWidth = UIScreen.mainScreen().bounds.width
        let sepView = UIView(frame: CGRect(x: 10, y: 101, width: bgWidth - 20, height: 0.5))
        sepView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.24)
        bgView.addSubview(sepView)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
