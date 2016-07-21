//
//  EndInterviewTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON


class EndInterviewTableViewController: UITableViewController {

    let evaluateTableViewCell = "EvaluateTableViewCell"
    let resultTableViewCell = "ResultTableViewCell"
    let titleArray = ["您今日的战绩如下","请为今日面试安排做出评价","其他改进建议"]
    let interviewProgress = InterviewProgress()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "EvaluateTableViewCell", bundle: nil), forCellReuseIdentifier: evaluateTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: resultTableViewCell)

        self.setBackButton()
        
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        let seedUrl = endOneInterview
        var parameters = ["interviewinfov2id":INTERVIEWID!, "employeeId":userinfo.employeeid!] as! [String: AnyObject]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseOneInterview)
        
    }
    
    func praseOneInterview(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            interviewProgress.getInfo(json)
        }
        if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)){
            let resultCell = cell as! ResultTableViewCell
            resultCell.interviewedApplicant.text = String(interviewProgress.interviewedApplicant)
            resultCell.passedApplicant.text = String(interviewProgress.passedApplicant)
            resultCell.passedRate.text = interviewProgress.passedRate
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var returnCell = UITableViewCell()
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(resultTableViewCell, forIndexPath: indexPath) as! ResultTableViewCell
            
            returnCell = cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(evaluateTableViewCell, forIndexPath: indexPath) as! EvaluateTableViewCell
            
            returnCell = cell
        }else if indexPath.section == 2{
            
            let width = UIScreen.mainScreen().bounds.width
            let textField = UITextView(frame: CGRect(x: 15, y: 0, width: width - 30, height: 150))
            textField.backgroundColor = BACKGROUNDCOLOR
            textField.layer.cornerRadius = 5
            textField.layer.masksToBounds = true
            returnCell.addSubview(textField)
            
        }
        
        returnCell.selectionStyle = .None
        
        return returnCell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        
        if indexPath.section == 0{
            rowHeight = 130
        }else if indexPath.section == 1{
            rowHeight = 160
        }else if indexPath.section == 2{
            rowHeight = 150
        }
        
        return rowHeight
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 44
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let width = UIScreen.mainScreen().bounds.width
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        sectionView.backgroundColor = UIColor.whiteColor()
//        let sepView1 = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
//        sepView1.backgroundColor = SEPERATORCOLOR
//        sectionView.addSubview(sepView1)
//        
//        let sepView2 = UIView(frame: CGRect(x: 0, y: 43.5, width: width, height: 0.5))
//        sepView2.backgroundColor = SEPERATORCOLOR
//        sectionView.addSubview(sepView2)
        
        //色块view
        let decorateView = UIView(frame: CGRect(x: 0, y: 16, width: 3, height: 12))
        decorateView.backgroundColor = SYSTEMCOLOR
        sectionView.addSubview(decorateView)
        let sectionLabel = UILabel(frame: CGRect(x: 16, y: 16, width: width - 50, height: 14))
        sectionLabel.text = self.titleArray[section]
        sectionLabel.textColor = UIColor(red: 0x64/255, green: 0x64/255, blue: 0x64/255, alpha: 1)
        sectionLabel.font = UIFont.boldSystemFontOfSize(14)
        sectionView.addSubview(sectionLabel)
        
        return sectionView
        
    }
    
    
    @IBAction func endInterview(sender: AnyObject) {
        
        var indexPath = NSIndexPath(forRow: 0, inSection: 1)
        var cell = self.tableView.cellForRowAtIndexPath(indexPath) as! EvaluateTableViewCell
        let stars = cell.getResult()
        
        indexPath = NSIndexPath(forRow: 0, inSection: 2)
        let adviceCell = self.tableView.cellForRowAtIndexPath(indexPath)
        let textField = adviceCell!.subviews.last as! UITextView
        var advice = textField.text
        if advice == nil{
            advice = ""
        }
        
        HUD.show(.RotatingImage(loadingImage))
        
        let seedUrl = interviewerEndInterview
        var parameters = ["interviewinfov2id":INTERVIEWID!, "employeeId":userinfo.employeeid!, "thought1":stars[0], "thought2":stars[1], "thought3":stars[2], "thought4":stars[3], "others": advice] as! [String: AnyObject]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseEndInterview)
        
        
    }
    
    func praseEndInterview(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            let alertView = UIAlertController(title: "提醒", message: "提交评价结果成功", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){ (UIAlertAction) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            
        }
        else{
            let alertView = UIAlertController(title: "提醒", message: "提交失败，请重新提交", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        HUD.hide()
    }
    

}
