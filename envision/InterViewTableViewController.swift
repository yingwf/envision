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
    
    var refreshController = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshController.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.refreshController.addTarget(self, action: "refreshList", forControlEvents: .ValueChanged)
        
        self.tableView.addSubview(refreshController)
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "InterviewTableViewCell", bundle: nil), forCellReuseIdentifier: interviewCell)
        self.setBackButton()
        
        HUD.show(.RotatingImage(loadingImage))
        let seedUrl = getMyInterviewerInfoList
        let parameters = ["Email":userinfo.email!]
        afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseMyInterview)
        
    }

    func praseMyInterview(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            
            let interviews = json["data"].array!
            if interviews.count > 0{
                var tempList = [MyInterView]()
                for index in 0...interviews.count - 1{
                    let myInterview = MyInterView()
                    myInterview.getMyInterView(interviews[index])
                    tempList.append(myInterview)
                }
                self.myInterviews = tempList
            }
            
            self.refreshController.endRefreshing()
            self.tableView.reloadData()
        }
        HUD.hide()
    }
    
    func refreshList() {
        
        let seedUrl = getMyInterviewerInfoList
        let parameters = ["Email":userinfo.email!]
        afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseMyInterview)
        
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
        
        var time = "时间："
        if let theTime = self.myInterviews[indexPath.row].time {
            time += theTime
        }
        if let duration = self.myInterviews[indexPath.row].duration {
            time += " | \(duration)小时"
        }
        if let personAmount = self.myInterviews[indexPath.row].personAmount {
            time += " | \(personAmount)人"
        }
        
        cell.time.text = time

        var address = "地点："
        if let location = self.myInterviews[indexPath.row].location {
            address += location
        }
        cell.address.text = address
        
        var session = "面试轮次："
        if let theSession = self.myInterviews[indexPath.row].session {
            if theSession != 99{
                session += "第\(theSession)轮"
            }else{
                session += "终面"
            }
        }
        cell.session.text = session
        
        cell.date.text = self.myInterviews[indexPath.row].date
        
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
        let tag = tap.view?.tag
        let cvListTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CVListTableViewController") as! CVListTableViewController
        INTERVIEWID = self.myInterviews[tag!].interviewId
        cvListTableViewController.cvListType = .MyInterview
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
        return 171
    }
    
    
}
