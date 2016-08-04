//
//  MyApplyTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/27.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import AudioToolbox

protocol UpdateInterviewInfoDelegate {
    func updateInterviewTime(interviewInfo: InterviewInfo)
}

class MyApplyTableViewController: UITableViewController,UpdateInterviewInfoDelegate {

    let applyPosTableViewCell = "ApplyPosTableViewCell"
    let applyProTableViewCell = "ApplyProTableViewCell"
    let applyStatusTableViewCell = "ApplyStatusTableViewCell"
    let applyCVTableViewCell = "ApplyCVTableViewCell"
    let applyInterviewTableViewCell = "ApplyInterviewTableViewCell"
    let applyFinalTableViewCell = "ApplyFinalTableViewCell"
    let applyOfferTableViewCell = "ApplyOfferTableViewCell"
    
    var interview = ApplicantInterview()
    var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshController.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.refreshController.addTarget(self, action: "refreshData", forControlEvents: .ValueChanged)
        
        self.tableView.addSubview(refreshController)
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = UIColor(red: 0xf0/255, green: 0xfb/255, blue: 0xff/255, alpha: 1)
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "ApplyPosTableViewCell", bundle: nil), forCellReuseIdentifier: applyPosTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyProTableViewCell", bundle: nil), forCellReuseIdentifier: applyProTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyStatusTableViewCell", bundle: nil), forCellReuseIdentifier: applyStatusTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyCVTableViewCell", bundle: nil), forCellReuseIdentifier: applyCVTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyInterviewTableViewCell", bundle: nil), forCellReuseIdentifier: applyInterviewTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyFinalTableViewCell", bundle: nil), forCellReuseIdentifier: applyFinalTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyOfferTableViewCell", bundle: nil), forCellReuseIdentifier: applyOfferTableViewCell)

        self.setBackButton()
        
        HUD.show(.RotatingImage(loadingImage))
        let url = myInterview
        let parameters = ["applicantId":userinfo.beisen_id!]
        afRequest(url, parameters: parameters, encoding: .URL, praseMethod: praseInterview)

    }
    
    func praseInterview(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            self.interview.getInfo(json)
            self.tableView.reloadData()
            
            if interview.interviewPhase == 3 && (interview.interviewStatus == 2 || (interview.interviewStatus == 1 && interview.lineInfo?.count <= 2)) {
                //已开始面试，或签到后，排队人数小于等于2位时，震动提醒
                systemAlert()
            }
        }
        HUD.hide()
        self.refreshController.endRefreshing()
    }
    
    func refreshData() {
        
        let url = myInterview
        let parameters = ["applicantId":userinfo.beisen_id!]
        afRequest(url, parameters: parameters, encoding: .URL, praseMethod: praseInterview)
        
    }
    
    
    func praseLineNumber(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            let lineData = json["info"]
            interview.lineInfo = LineInfo()
            interview.lineInfo!.getLineInfo(lineData)
            guard let lineNumber = self.interview.lineInfo?.lineNumber, count = self.interview.lineInfo?.count else {
                let alertView = UIAlertController(title: "提醒", message: "排队信息获取有误，请重新签到", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil )
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: false, completion: nil)
                return
            }
            
            let alertView = UIAlertController(title: "二维码扫描结果", message: "已签到，你的排队号是\(lineNumber)，前面还有\(count)个", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){(action) in
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)

            self.interview.interviewStatus = 1//已签到，开始排队
            let indexPath1 = NSIndexPath(forRow: 3, inSection: 0)
            let indexPath2 = NSIndexPath(forRow: 4, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath1, indexPath2], withRowAnimation: .Automatic)
        }else{
            var message = "排队信息获取有误，请重新签到"
            if json["message"].string != nil {
                message = json["message"].string!
            }
            let alertView = UIAlertController(title: "二维码扫描结果", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler:nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
        
        HUD.hide()
    }
    
    func systemAlert() {
        
        var soundID:SystemSoundID = 1005 //alarm
        AudioServicesPlayAlertSound(soundID)
        
        soundID = SystemSoundID(kSystemSoundID_Vibrate) //振动
        AudioServicesPlaySystemSound(soundID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateInterviewTime(interviewInfo: InterviewInfo){
        self.interview.interviewInfo = interviewInfo
        self.interview.interviewStatus = 3 //已选择面试时间
        let indexPath = NSIndexPath(forRow: 3, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func updateInfo(){
        HUD.show(.RotatingImage(loadingImage))
        let url = myInterview
        let parameters = ["applicantId":userinfo.beisen_id!]
        afRequest(url, parameters: parameters, encoding: .URL, praseMethod: praseInterview)
    }

    func capture(){
        
        let qrcodevc = SYQRCodeViewController()
        qrcodevc.SYQRCodeSuncessBlock = {(aqrvc:SYQRCodeViewController!, qrString:String!) -> Void in
            if qrString.hasPrefix(ROOTURL){
                self.navigationController?.popViewControllerAnimated(true)
                HUD.show(.RotatingImage(loadingImage))
                let seedUrl = qrString + "&applicantId=\(userinfo.beisen_id!)"
                afRequest(seedUrl, parameters: nil, encoding: .URL, praseMethod: self.praseLineNumber)
            }else{
                
                let alertView = UIAlertController(title: "二维码扫描结果", message: "不是签到二维码，请重新签到", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default){(action) in
                    self.navigationController?.popViewControllerAnimated(true)
                }
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: false, completion: nil)
            }

        }
        qrcodevc.SYQRCodeFailBlock = {(aqrvc:SYQRCodeViewController!) -> Void in
            let alertView = UIAlertController(title: "二维码扫描结果", message: "扫描失败", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){(action) in
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
        qrcodevc.SYQRCodeCancleBlock = {(aqrvc:SYQRCodeViewController!) -> Void in
            let alertView = UIAlertController(title: "二维码扫描结果", message: "扫描取消", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){(action) in
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
        
        self.navigationController?.pushViewController(qrcodevc, animated: true)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 && self.interview.interviewPhase == 1 && self.interview.interviewStatus == 0{
            //未申请时，可选
            
            isFromMyInterview = true //标示从这个页面选择职位
            let applyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ApplyTableViewController") as! ApplyTableViewController
            applyViewController.setButton = true
            self.navigationController?.pushViewController(applyViewController, animated: true)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var returnCell = UITableViewCell()
        let indicatorImage = UIImageView(frame: CGRect(x: 12, y: 10, width: 32, height: 24))
        indicatorImage.image = UIImage(named: "currentStatus")
        indicatorImage.tag = 100
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyPosTableViewCell, forIndexPath: indexPath) as! ApplyPosTableViewCell
            if self.interview.interviewPhase == 1 && self.interview.interviewStatus == 0{
                //未申请
                cell.jobTitle.text = "未申请"
                cell.accessoryType = .DisclosureIndicator
                cell.selectionStyle = .Default
            }else{
                cell.jobTitle.text = self.interview.jobInfo?.jobTitle
                cell.accessoryType = .None
                cell.selectionStyle = .None
            }

            returnCell = cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyProTableViewCell, forIndexPath: indexPath) as! ApplyProTableViewCell
            cell.selectionStyle = .None
            returnCell = cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyStatusTableViewCell, forIndexPath: indexPath) as! ApplyStatusTableViewCell
            
            if self.interview.interviewPhase == 1 {
                cell.contentView.addSubview(indicatorImage)
                switch self.interview.interviewStatus! {
                case 0:
                    //未申请
                    cell.setHide()
                case 1:
                    //已申请
                    cell.setApplied()
                    cell.emailLabel.text = userinfo.email
                default:
                    print("default")
                }
            }else{
                //非该阶段，隐藏信息
                cell.setHide()
                if cell.subviews.last?.tag == 100 {
                    cell.subviews.last?.removeFromSuperview()
                }
                
            }
            
            cell.selectionStyle = .None
            returnCell = cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyCVTableViewCell, forIndexPath: indexPath) as! ApplyCVTableViewCell
            
            if self.interview.interviewPhase == 2 {
                cell.contentView.addSubview(indicatorImage)
                switch self.interview.interviewStatus! {
                case 0:
                    //0简历筛选中
                    cell.setCvProcessing()
                case 1:
                    //1简历筛选通过，且面试时间未安排
                    cell.setCvPass()
                case 2:
                    //2简历筛选通过，且面试时间已安排，面试时间未选择
                    cell.setSelectTime()
                    cell.selectButton.addTarget(self, action: "selectTime:", forControlEvents: .TouchUpInside)
                case 3:
                    //3简历筛选通过，且面试时间已安排，面试时间已选择
                    if self.interview.interviewInfo != nil {
                        cell.setTimeSelected(self.interview.interviewInfo!)
                    }
                case 4:
                    //4简历筛选通过，且面试时间已安排，放弃面试
                    cell.setCvGiveup()
                case 5:
                    //5简历筛选失败
                    cell.setCvNotPass()
                default:
                    print("default")
                }
            }else if self.interview.interviewPhase == 3 && self.interview.interviewStatus == 0 && self.interview.lineInfo?.interviewNumber == 1 {
                //初试，未开始，未签到时，需显示时间地点信息
                if self.interview.interviewInfo != nil {
                    cell.setTimeSelected(self.interview.interviewInfo!)
                }
                if cell.subviews.last?.tag == 100 {
                    cell.subviews.last?.removeFromSuperview()
                }
            }else{
                cell.setHide()
                if cell.subviews.last?.tag == 100 {
                    cell.subviews.last?.removeFromSuperview()
                }
            }

            cell.selectionStyle = .None
            returnCell = cell

        }else if indexPath.row == 4{
            
            if self.interview.interviewPhase == 3 {
                switch self.interview.interviewStatus! {
                case 0:
                    //0未开始，未签到
                    let cell = tableView.dequeueReusableCellWithIdentifier(applyInterviewTableViewCell, forIndexPath: indexPath) as! ApplyInterviewTableViewCell
                    cell.interviewInfo = self.interview
                    cell.setBeginToSign()
                    
                    cell.capture.userInteractionEnabled = true
                    let captureTap = UITapGestureRecognizer(target: self, action: "capture")
                    cell.capture.addGestureRecognizer(captureTap)
                    cell.contentView.addSubview(indicatorImage)
                    cell.selectionStyle = .None
                    returnCell = cell
                    
                case 1:
                    //1未开始，已签到
                    let cell = tableView.dequeueReusableCellWithIdentifier(applyFinalTableViewCell, forIndexPath: indexPath) as! ApplyFinalTableViewCell
                    cell.interviewInfo = self.interview
                    cell.setHaveSigned()
                    cell.contentView.addSubview(indicatorImage)
                    cell.selectionStyle = .None
                    returnCell = cell
                    
                case 2:
                    //2已开始
                    let cell = tableView.dequeueReusableCellWithIdentifier(applyFinalTableViewCell, forIndexPath: indexPath) as! ApplyFinalTableViewCell
                    cell.interviewInfo = self.interview
                    cell.setBeginInterview()
                    cell.contentView.addSubview(indicatorImage)
                    cell.selectionStyle = .None
                    returnCell = cell
                    
                case 3:
                    //3面试结束，已通过，还有下一轮
                    let cell = tableView.dequeueReusableCellWithIdentifier(applyInterviewTableViewCell, forIndexPath: indexPath) as! ApplyInterviewTableViewCell
                    cell.interviewInfo = self.interview
                    cell.setPassAndNotEnd()
                    
                    cell.capture.userInteractionEnabled = true
                    let captureTap = UITapGestureRecognizer(target: self, action: "capture")
                    cell.capture.addGestureRecognizer(captureTap)
                    
                    cell.contentView.addSubview(indicatorImage)
                    cell.selectionStyle = .None
                    returnCell = cell
                    
                case 4:
                    //4面试结束，已通过，没有下一轮（今天面试结束）
                    let cell = tableView.dequeueReusableCellWithIdentifier(applyFinalTableViewCell, forIndexPath: indexPath) as! ApplyFinalTableViewCell
                    cell.interviewInfo = self.interview
                    cell.setPassAndEnd()
                    cell.contentView.addSubview(indicatorImage)
                    cell.selectionStyle = .None
                    returnCell = cell
                    
                case 5:
                    //5面试结束，未通过
                    let cell = tableView.dequeueReusableCellWithIdentifier(applyFinalTableViewCell, forIndexPath: indexPath) as! ApplyFinalTableViewCell
                    cell.setEndAndNotPass()
                    cell.contentView.addSubview(indicatorImage)
                    cell.selectionStyle = .None
                    returnCell = cell
                    
                default:
                    print("default")
                
                }
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier(applyInterviewTableViewCell, forIndexPath: indexPath) as! ApplyInterviewTableViewCell
                cell.setHide()
                if cell.subviews.last?.tag == 100 {
                    cell.subviews.last?.removeFromSuperview()
                }
                
                cell.selectionStyle = .None
                returnCell = cell
                
            }
            

        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyOfferTableViewCell, forIndexPath: indexPath) as! ApplyOfferTableViewCell
            
            if self.interview.interviewPhase == 4 {
                cell.contentView.addSubview(indicatorImage)
                switch self.interview.interviewStatus! {
                case 0:
                    //0已发offer
                    cell.setHaveSended()
                    
                default:
                    print("default")
                }
            }else{
                cell.setHide()
                if cell.subviews.last?.tag == 100 {
                    cell.subviews.last?.removeFromSuperview()
                }
            }
            
            cell.selectionStyle = .None
            returnCell = cell
        }

        return returnCell
    }
    
    func selectTime(sender: UIButton){
        let timeSelectTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TimeSelectTableViewController") as! TimeSelectTableViewController
        timeSelectTableViewController.delegate = self
        self.navigationController?.pushViewController(timeSelectTableViewController, animated: true)

    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        
        if indexPath.row == 0{
            rowHeight = 62
        }else if indexPath.row == 1{
            rowHeight = 59
        }else if indexPath.row == 2{
            if self.interview.interviewPhase == 1 {
                switch self.interview.interviewStatus! {
                case 0:
                    rowHeight = 54
                case 1:
                    rowHeight = 115
                default:
                    rowHeight = 115
                }
            }else{
                rowHeight = 54
            }

        }else if indexPath.row == 3{
            if self.interview.interviewPhase == 2 {
                switch self.interview.interviewStatus! {
                case 0,1,4,5:
                    rowHeight = 74
                default:
                    rowHeight = 136
                }
            }else if self.interview.interviewPhase == 3 && self.interview.interviewStatus == 0 && self.interview.lineInfo?.interviewNumber == 1 {
                rowHeight = 136
            }else{
                rowHeight = 54
            }
        }else if indexPath.row == 4{
            if self.interview.interviewPhase == 3{
                switch self.interview.interviewStatus! {
                case 0,3:
                    rowHeight = 271
                case 1,2:
                    rowHeight = 305
                case 4,5:
                    rowHeight = 74
                default:
                    rowHeight = 74
                }
            }else{
                rowHeight = 54
            }

        }else if indexPath.row == 5{
            if self.interview.interviewPhase == 4 {
                switch self.interview.interviewStatus! {
                case 0:
                    rowHeight = 88
                default:
                    rowHeight = 88
                }
            }else{
                rowHeight = 54
            }
        }
        
        return rowHeight
    }

}
