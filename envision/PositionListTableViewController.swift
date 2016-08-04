//
//  PositionListTableViewController.swift
//  envision
//
//  Created by  ywf on 16/5/31.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol updateRowInfoDelegate{
    func updateRowInfo(job: Job)
}

class PositionListTableViewController: UITableViewController,updateRowInfoDelegate {
    
    let positionTitle = ["能源互联网软件类","智能风机与智慧风场研发类","智慧供应链类","智慧光伏类"]
    
    let positionListCell = "PositionListTableViewCell"
    
    var jobLists = [JobList]()
    
    var currentIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setBackButton()

        
        //self.tableView.tableFooterView = UIView() //取消多余的分割线
        //self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "PositionListTableViewCell", bundle: nil), forCellReuseIdentifier: positionListCell)
        
        HUD.show(.RotatingImage(loadingImage))
        let seedUrl = getJobList
        var parameters = ["Category":1] as! [String: AnyObject]
        if userinfo.beisen_id != nil{
            parameters["applicantId"] = userinfo.beisen_id!
        }
        afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseJobList)
    }
    
    func praseJobList(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            let jobData = json["data"].array!
            if jobData.count > 0{
                for index in 0...jobData.count - 1{
                    let jobList = JobList()
                    jobList.getJobList(jobData[index])
                    self.jobLists.append(jobList)
                }
            }
            self.tableView.reloadData()
        }
        HUD.hide()
    }
    
//    func backToPrevious(){
//        self.navigationController?.popViewControllerAnimated(true)
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return jobLists.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobLists[section].jobs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(positionListCell, forIndexPath: indexPath) as! PositionListTableViewCell
        cell.jobTitle.text = self.jobLists[indexPath.section].jobs[indexPath.row].jobTitle
        cell.major.text = self.jobLists[indexPath.section].jobs[indexPath.row].MBYZ
        cell.address.text = self.jobLists[indexPath.section].jobs[indexPath.row].address
        
        if userinfo.beisen_id != nil && userinfo.type != 3{
            cell.favorImage.hidden = false
            let isCollect = self.jobLists[indexPath.section].jobs[indexPath.row].isCollect
            if isCollect != nil && isCollect! {
                cell.favorImage.image = UIImage(named: "collected")
            }else{
                cell.favorImage.image = UIImage(named: "uncollected")
            }
        }else{
            //面试官用户，隐藏
            cell.favorImage.hidden = true
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 73
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

        let sepView2 = UIView(frame: CGRect(x: 0, y: 43.5, width: width, height: 0.5))
        sepView2.backgroundColor = SEPERATORCOLOR
        sectionView.addSubview(sepView2)
        
        //色块view
        let decorateView = UIView(frame: CGRect(x: 0, y: 16, width: 3, height: 12))
        decorateView.backgroundColor = SYSTEMCOLOR
        sectionView.addSubview(decorateView)
        let sectionLabel = UILabel(frame: CGRect(x: 16, y: 16, width: width - 50, height: 12))
        sectionLabel.text =  self.jobLists[section].ZWFL //  self.positionTitle[section]
        sectionLabel.textColor = UIColor(red: 0x64/255, green: 0x64/255, blue: 0x64/255, alpha: 1)
        sectionView.addSubview(sectionLabel)
        
        return sectionView
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        
        let positionDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PositionDetailViewController") as! PositionDetailViewController
        
        positionDetailViewController.jobid = self.jobLists[indexPath.section].jobs[indexPath.row].jobid!
        positionDetailViewController.delegate = self
        
        self.currentIndexPath = indexPath
        
        self.navigationController?.pushViewController(positionDetailViewController, animated: true)
        
    }

    func updateRowInfo(job: Job){
        if self.currentIndexPath == nil{
            return
        }
        self.jobLists[currentIndexPath!.section].jobs[currentIndexPath!.row].isCollect = job.isCollect
        self.tableView.reloadRowsAtIndexPaths([self.currentIndexPath!], withRowAnimation: .None)
        
    }
    
}
