//
//  CVListTableViewController.swift
//  envision
//
//  Created by  ywf on 16/7/8.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CVListType: Int {
    case MyInterview = 0, CurrentList, NextList
}

class CVListTableViewController: UITableViewController {

    let cvListCell = "CVListTableViewCell"
    var cvInfos = [CvInfo]()
    var refreshController = UIRefreshControl()
    var cvListType:CVListType = .MyInterview

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButton()
        
//        self.refreshController.attributedTitle = NSAttributedString(string: "下拉刷新")
//        self.refreshController.addTarget(self, action: "refreshList", forControlEvents: .ValueChanged)
        
        self.tableView.addSubview(refreshController)
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.registerNib(UINib(nibName: "CVListTableViewCell", bundle: nil), forCellReuseIdentifier: cvListCell)
        
        switch cvListType {
        case .MyInterview:
            HUD.show(.RotatingImage(loadingImage))
            let seedUrl = getApplicantListForMyInterview
            let parameters = ["interviewId":String(INTERVIEWID!),"Email":userinfo.email!] as! [String:AnyObject]
            afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseCvList)
        default:
            self.tableView.reloadData()
        }
        
    }
    
    func praseCvList(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            let cvData = json["data"].array!
            if cvData.count > 0{
                var tempList = [CvInfo]()
                for index in 0...cvData.count - 1{
                    let cvInfo = CvInfo()
                    cvInfo.getCvInfo(cvData[index])
                    tempList.append(cvInfo)
                }
                self.cvInfos = tempList
            }
            self.tableView.reloadData()
        }
        HUD.hide()
        //self.refreshController.endRefreshing()
    }
    
//    func refreshList() {
//        
//        let seedUrl = getApplicantListForMyInterview
//        let parameters = ["interviewId":String(INTERVIEWID!),"Email":userinfo.email!] as! [String:AnyObject]
//        afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseCvList)
//        
//    }

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
        return cvInfos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cvListCell, forIndexPath: indexPath) as! CVListTableViewCell
        cell.headImg.imageFromUrl(self.cvInfos[indexPath.row].img)
        cell.name.text = self.cvInfos[indexPath.row].name
        cell.school.text = self.cvInfos[indexPath.row].lastschool

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 69
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        guard let ElinkUrl = self.cvInfos[indexPath.row].ElinkUrl else{
            return
        }
        
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("FullResumeViewController") as! FullResumeViewController
        
        introViewController.webSite =  ElinkUrl //  fullresume + "?applicantId=\(applicantId)"
        
        self.navigationController?.pushViewController(introViewController, animated: true)
        
        
    }
    
    
    
    
    
}
