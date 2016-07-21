//
//  ApplyInterviewTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/27.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class ApplyInterviewTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var capture: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var currentStatus: UILabel!
    
    @IBOutlet weak var hint: UILabel!
    
    @IBOutlet weak var alertImage: UIImageView!
    
    var interviewInfo = ApplicantInterview()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.bgView.layer.cornerRadius = 5
        self.bgView.layer.masksToBounds = true
        
        let width = self.bgView.frame.width
//        let sepView = UIView(frame: CGRect(x: 28, y: 54, width: width - 28, height: 0.5))
//        sepView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.1)
//        self.bgView.addSubview(sepView)
        
        let sepBView = UIView(frame: CGRect(x: 28, y: 221, width: width - 28, height: 0.5))
        sepBView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.1)
        self.bgView.addSubview(sepBView)
        
    }
    
    func getSessionTitle() ->String{
        var sessionTitle = ""
        let interviewNumber = interviewInfo.lineInfo?.interviewNumber
        if let number = interviewNumber{
            let numberText = ["一","二","三","四","五","六","七","八","九","十"]
            if number >= 1 && number <= 10 {
                sessionTitle += "（第\(numberText[number - 1])场）"
            }else{
                sessionTitle += "（终面）"
            }
        }
        return sessionTitle
    }
    func setHide(){
        //未到该阶段
        self.currentStatus.hidden = true
        self.capture.hidden = true
        self.hint.hidden = true
        self.alertImage.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 34
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 54
        self.contentView.frame = contentFrame
        
    }
    
    func setBeginToSign(){
        //初试
        var status = "面试进行中" + getSessionTitle()
        
        if self.interviewInfo.lineInfo?.interviewNumber == 99{
            //终面通知
            var address = interviewInfo.interviewInfo?.location
            if address == nil{
                address = ""
            }
            var startTime = interviewInfo.interviewInfo?.startTime
            if startTime == nil{
                startTime = ""
            }
            
            status = "最终面试，时间：\(startTime!)，地点：\(address!)，请准时参加"
        }

        self.currentStatus.text = status
        
        self.currentStatus.hidden = false
        self.capture.hidden = false
        self.hint.hidden = false
        self.alertImage.hidden = false
    }

    func setPassAndNotEnd(){
        //面试通过，还有下一轮
        var address = interviewInfo.interviewInfo?.location
        if address == nil{
            address = ""
        }
        
        let status = "面试已通过，请到\(address!)准备下一轮面试" //\(getSessionTitle())"
        self.currentStatus.text = status
        self.currentStatus.sizeToFit()
        self.currentStatus.hidden = false
        self.capture.hidden = false
        self.hint.hidden = false
        self.alertImage.hidden = false
    }
    
//    func setLastInterview(){
//        //终面通知
//        var address = interviewInfo.interviewInfo?.location
//        if address == nil{
//            address = ""
//        }
//        var startTime = interviewInfo.interviewInfo?.startTime
//        if startTime == nil{
//            startTime = ""
//        }
//        
//        let status = "最终面试，时间：\(startTime)，地点：\(address)，请准时参加"
//        self.currentStatus.text = status
//        self.currentStatus.sizeToFit()
//        self.currentStatus.hidden = false
//        self.capture.hidden = false
//        self.hint.hidden = false
//        self.alertImage.hidden = false
//    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
