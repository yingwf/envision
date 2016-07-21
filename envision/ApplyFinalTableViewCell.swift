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
    @IBOutlet weak var lineNumber: UILabel!
    @IBOutlet weak var nowStatus: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var standByImage: UIImageView!
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var nowTitle: UILabel!
    @IBOutlet weak var alertImage: UIImageView!
    
    var interviewInfo = ApplicantInterview()
    
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
    
    func setTitle(){
        let interviewNumber = self.interviewInfo.lineInfo?.interviewNumber
        
        var status = "面试进行中"
        if let number = interviewNumber{
            let numberText = ["一","二","三","四","五","六","七","八","九","十"]
            if number >= 1 && number <= 10 {
                status += "（第\(numberText[number - 1])场）"
            }else{
                status += "（终面）"
            }
        }
        self.nowTitle.text = status
    }
    
    func setHaveSigned(){

        self.nowTitle.hidden = false
        self.lineNumber.hidden = false
        self.nowStatus.hidden = false
        self.standByImage.hidden = false
        self.currentImage.hidden = false
        self.hint.hidden = false
        self.status.hidden = false
        self.alertImage.hidden = false
        
        self.setTitle()

        var lineNumber = self.interviewInfo.lineInfo?.lineNumber
        if lineNumber == nil{
            lineNumber = 0
        }
        var nowLineNumber = self.interviewInfo.lineInfo?.nowLineNumber
        if nowLineNumber == nil{
            nowLineNumber = 0
        }
        var count = self.interviewInfo.lineInfo?.count
        if count == nil{
            count = 0
        }
        
        self.lineNumber.text = String(lineNumber!)
        self.nowStatus.text = "当前面试到\(nowLineNumber!)号，前面还有\(count!)人。"
    }

    func setBeginInterview(){
        self.setTitle()
        self.nowTitle.hidden = false
        self.lineNumber.hidden = false
        self.nowStatus.hidden = false
        self.standByImage.hidden = false
        self.currentImage.hidden = false
        self.hint.hidden = false
        self.status.hidden = false
        self.alertImage.hidden = false

        
        self.standByImage.image = UIImage(named:"icon5_Interview")
        self.status.text = "面试进行中"
        
        var roomNo = self.interviewInfo.roomInfo?.roomNo
        if roomNo == nil{
            roomNo = ""
        }
        var deskNo = self.interviewInfo.roomInfo?.deskNo
        if deskNo == nil{
            deskNo = ""
        }
        self.lineNumber.text = "\(roomNo!)号房间"
        self.nowStatus.text = "面试开始，请前往\(roomNo!)号房间\(deskNo!)号桌"
        
    }
    
    
    func setPassAndEnd(){
        //面试通过，今天面试结束
        
        var status = "面试已结束，请等待后续通知"
        if self.interviewInfo.lineInfo?.interviewNumber == 99{
            //终面
            status = "面试已结束，请等待后续通知"
        }
        
        self.nowTitle.text = status
        self.nowTitle.hidden = false
        self.lineNumber.hidden = true
        self.nowStatus.hidden = true
        self.standByImage.hidden = true
        self.currentImage.hidden = true
        self.hint.hidden = true
        self.status.hidden = true
        self.alertImage.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 54
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 74
        self.contentView.frame = contentFrame
    }

    func setEndAndNotPass(){
        var status = "很遗憾，本轮面试你没有通过"
        if self.interviewInfo.lineInfo?.interviewNumber == 99{
            //终面
            status = "面试已结束，请等待后续通知"
        }
        
        self.nowTitle.text = status
        self.nowTitle.hidden = false
        self.lineNumber.hidden = true
        self.nowStatus.hidden = true
        self.standByImage.hidden = true
        self.currentImage.hidden = true
        self.hint.hidden = true
        self.status.hidden = true
        self.alertImage.hidden = true
        
        var viewFrame = self.bgView.frame
        viewFrame.size.height = 54
        self.bgView.frame = viewFrame
        
        var contentFrame = self.contentView.frame
        contentFrame.size.height = 74
        self.contentView.frame = contentFrame
    }
    
//    func setLastInterviewEnd(){
//        self.nowTitle.text = "面试已结束，请等待后续通知"
//        self.nowTitle.hidden = false
//        self.lineNumber.hidden = true
//        self.nowStatus.hidden = true
//        self.standByImage.hidden = true
//        self.currentImage.hidden = true
//        self.hint.hidden = true
//        self.status.hidden = true
//        self.alertImage.hidden = true
//        
//        var viewFrame = self.bgView.frame
//        viewFrame.size.height = 54
//        self.bgView.frame = viewFrame
//        
//        var contentFrame = self.contentView.frame
//        contentFrame.size.height = 74
//        self.contentView.frame = contentFrame
//    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
