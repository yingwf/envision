//
//  InterviewMgrViewController.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON


class InterviewMgrViewController: UIViewController {

    @IBOutlet weak var currentApplicant: UIButton!
    @IBOutlet weak var nextApplicant: UIButton!
    @IBOutlet weak var endInterview: UIButton!
    
    @IBOutlet weak var waitApplicant: UILabel!
    @IBOutlet weak var interviewedApplicant: UILabel!
    @IBOutlet weak var passedApplicant: UILabel!
    @IBOutlet weak var passedRate: UILabel!

    
    var interviewProgress = InterviewProgress()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentApplicant.layer.cornerRadius = 5
        currentApplicant.layer.masksToBounds = true
        
        currentApplicant.layer.borderWidth = 0.5
        currentApplicant.layer.borderColor = SYSTEMCOLOR.CGColor
        
        nextApplicant.layer.cornerRadius = 5
        nextApplicant.layer.masksToBounds = true
        endInterview.layer.cornerRadius = 5
        endInterview.layer.masksToBounds = true
        
        let sepView = UIView(frame: CGRect(x: 16, y: 115, width: self.view.frame.width - 32, height: 0.5))
        sepView.backgroundColor = BACKGROUNDCOLOR
        self.view.addSubview(sepView)
        self.setBackButton()
        
        let seedUrl = getCurrentInterviewStatus
        var parameters = ["interviewId": String(INTERVIEWID!)] as! [String: AnyObject]
        afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseProgress)
        
        
    }
    
    func praseProgress(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            self.interviewProgress.getInfo(json)
            self.updateProgress()
        }
    }
    
    @IBAction func currentApplicant(sender: AnyObject) {
        
        HUD.show(.RotatingImage(loadingImage))
        
        let seedUrl = getCurrentUrl //interviewCurrentApplicant
        var parameters = ["employeeId":userinfo.employeeid! ] as! [String: AnyObject]
        afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseCurrentApplicant)
    }
    
    func praseCurrentApplicant(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            let eLinkUrl = json["ElinkUrl"].string
            if  eLinkUrl != nil && eLinkUrl != "" {
                let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
                introViewController.webSite = eLinkUrl!
                introViewController.navigationItem.title = "面试评价"
                self.navigationController?.pushViewController(introViewController, animated: true)
            }else{
                var message = "没有当前学生，请呼叫下一位"
                if json["message"].string != nil {
                    message = json["message"].string!
                }
                let alertView = UIAlertController(title: "提醒", message:message , preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: false, completion: nil)
            }
            
        }else{
            var message = "获取当前学生失败"
            if json["message"].string != nil {
                message = json["message"].string!
            }
            let alertView = UIAlertController(title: "提醒", message:message , preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
        HUD.hide()
    }
    
    @IBAction func nextApplicant(sender: AnyObject) {
        guard INTERVIEWID != nil && userinfo.employeeid != nil else{
            return
        }
        
        HUD.show(.RotatingImage(loadingImage))
        
        let seedUrl = interviewNextApplicant
        let parameters = ["interviewId": String(INTERVIEWID!), "employeeId":userinfo.employeeid! ] as! [String: AnyObject]
        afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseNextApplicant)
        
    }
    
    func praseNextApplicant(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            self.interviewProgress.getInfo(json)
            self.updateProgress()
            if let eLinkUrl = self.interviewProgress.ElinkUrl {
                let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
                introViewController.webSite = eLinkUrl
                introViewController.navigationItem.title = "面试评价"
                self.navigationController?.pushViewController(introViewController, animated: true)
            }else{
                var message = "获取下一位学生简历出错"
                if json["message"].string != nil {
                    message = json["message"].string!
                }
                let alertView = UIAlertController(title: "提醒", message:message , preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: false, completion: nil)
            }
        }else{
                var message = "获取下一位学生简历出错"
                if json["message"].string != nil {
                    message = json["message"].string!
                }
                let alertView = UIAlertController(title: "提醒", message:message , preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: false, completion: nil)
        }
        HUD.hide()
    }
    
    
    
    func updateProgress(){
        if interviewProgress.waitApplicant != nil{
            self.waitApplicant.text = String(interviewProgress.waitApplicant!)
        }
        if interviewProgress.interviewedApplicant != nil{
            self.interviewedApplicant.text = String(interviewProgress.interviewedApplicant!)
        }
        if interviewProgress.passedApplicant != nil{
            self.passedApplicant.text = String(interviewProgress.passedApplicant!)
        }
        self.passedRate.text = interviewProgress.passedRate
        
        
    }

    @IBAction func endInterview(sender: AnyObject) {
        
        let endInterviewTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EndInterviewTableViewController") as! EndInterviewTableViewController
        self.navigationController?.pushViewController(endInterviewTableViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
