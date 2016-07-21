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
    }
    
    @IBAction func currentApplicant(sender: AnyObject) {
        
        HUD.show(.RotatingImage(loadingImage))
        
        let seedUrl = interviewCurrentApplicant
        var parameters = ["applicantId":userinfo.beisen_id! ] as! [String: AnyObject]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseCurrentApplicant)
    }
    
    func praseCurrentApplicant(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            let eLinkUrl = json["ElinkUrl"].string
            if  eLinkUrl != nil && eLinkUrl != "" {
                let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
                introViewController.webSite = eLinkUrl!
                introViewController.navigationItem.title = "面试评价"
                self.navigationController?.pushViewController(introViewController, animated: true)
            }
            
        }
        HUD.hide()
    }
    
    @IBAction func nextApplicant(sender: AnyObject) {
        guard INTERVIEWID != nil && userinfo.employeeid != nil else{
            return
        }
        
        HUD.show(.RotatingImage(loadingImage))
        
        let seedUrl = interviewNextApplicant
        let parameters = ["interviewId": INTERVIEWID!, "employeeId":userinfo.employeeid! ] as! [String: AnyObject]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseNextApplicant)
        
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
            }
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
