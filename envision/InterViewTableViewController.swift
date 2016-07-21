//
//  InterViewTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/23.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON


class InterViewTableViewController: UITableViewController {
    let interviewCell = "InterviewTableViewCell"
    var myInterviews = [MyInterView]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "InterviewTableViewCell", bundle: nil), forCellReuseIdentifier: interviewCell)
        self.setBackButton()
        
        HUD.show(.RotatingImage(loadingImage))
        let seedUrl = getMyInterviewerInfoList
        let parameters = ["Email":userinfo.email!]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseMyInterview)
        
    }

    func praseMyInterview(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            let interviews = json["data"].array!
            if interviews.count > 0{
                for index in 0...interviews.count - 1{
                    let myInterview = MyInterView()
                    myInterview.getMyInterView(interviews[index])
                    self.myInterviews.append(myInterview)
                }
            }
            self.tableView.reloadData()
        }
        HUD.hide()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myInterviews.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(interviewCell, forIndexPath: indexPath) as! InterviewTableViewCell
        cell.jobName.text = self.myInterviews[indexPath.row].job
        cell.personAmount.text = String(self.myInterviews[indexPath.row].personAmount!)
        cell.duration.text = String(self.myInterviews[indexPath.row].duration!) + "H"
        cell.address.text = "地点：" + self.myInterviews[indexPath.row].location!
        cell.date.text = self.myInterviews[indexPath.row].date
        cell.time.text = self.myInterviews[indexPath.row].time
        let jobType = self.myInterviews[indexPath.row].job! as NSString
        cell.jobType.text = jobType.substringToIndex(1)
        
        cell.jobName.sizeToFit()
        //cell.date.sizeToFit()
        
        cell.readcv.userInteractionEnabled = true
        let readcvTap = UITapGestureRecognizer(target: self, action: "readcv:")
        cell.readcv.addGestureRecognizer(readcvTap)
        readcvTap.view?.tag = indexPath.row
        
        
        cell.interview.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "beginInterview:")
        cell.interview.addGestureRecognizer(tap)
        tap.view?.tag = indexPath.row

        return cell
    }
    
    func readcv(tap: UITapGestureRecognizer){
        let cvListTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CVListTableViewController") as! CVListTableViewController
        
        self.navigationController?.pushViewController(cvListTableViewController, animated: true)
    }
    
    
    func beginInterview(tap: UITapGestureRecognizer){
        let tag = tap.view?.tag
        let beginInterviewTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BeginInterviewTableViewController") as! BeginInterviewTableViewController
        beginInterviewTableViewController.myInterview = self.myInterviews[tag!]
        INTERVIEWID = self.myInterviews[tag!].interviewId
        
        self.navigationController?.pushViewController(beginInterviewTableViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 166
    }
    
    
}
