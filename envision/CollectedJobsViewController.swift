//
//  CollectedJobsViewController.swift
//  envision
//
//  Created by  ywf on 16/7/5.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON


class CollectedJobsViewController: UITableViewController,updateRowInfoDelegate {

    var jobs = [Job]()
    var currentJob: Job?
    let positionListCell = "PositionListTableViewCell"

    var currentIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setBackButton()
        
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.registerNib(UINib(nibName: "PositionListTableViewCell", bundle: nil), forCellReuseIdentifier: positionListCell)
        
        HUD.show(.RotatingImage(loadingImage))
        let seedUrl = getFavorJobList
        var parameters = ["applicantId":userinfo.beisen_id!] as! [String: AnyObject]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseJobList)
    
    }
    
    func praseJobList(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            if let jobData = json["data"].array{
                if jobData.count > 0{
                    for index in 0...jobData.count - 1{
                        let job = Job()
                        job.getJobInfo(jobData[index])
                        self.jobs.append(job)
                    }
                }
                self.tableView.reloadData()
            }
        }
        HUD.hide()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobs.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(positionListCell, forIndexPath: indexPath) as! PositionListTableViewCell
        cell.jobTitle.text = self.jobs[indexPath.row].jobTitle
        cell.major.text = self.jobs[indexPath.row].MBYZ
        cell.address.text = self.jobs[indexPath.row].address
        let isCollect = self.jobs[indexPath.row].isCollect
        if isCollect != nil && isCollect! {
            cell.favorImage.image = UIImage(named: "collected")
        }else{
            cell.favorImage.image = UIImage(named: "uncollected")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 73
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let positionDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PositionDetailViewController") as! PositionDetailViewController
        
        positionDetailViewController.jobid = self.jobs[indexPath.row].jobid!
        positionDetailViewController.delegate = self
        
        self.currentIndexPath = indexPath
        self.currentJob = self.jobs[indexPath.row]
        
        self.navigationController?.pushViewController(positionDetailViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateRowInfo(job: Job){
        if self.currentIndexPath == nil || job.isCollect == nil{
            return
        }
        if !job.isCollect!{
            //取消收藏
            self.jobs.removeAtIndex(self.currentIndexPath!.row)
        }else{
            //增加收藏
            self.jobs.insert(currentJob!, atIndex: self.currentIndexPath!.row)
        }
        self.tableView.reloadData()

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
