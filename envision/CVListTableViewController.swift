//
//  CVListTableViewController.swift
//  envision
//
//  Created by  ywf on 16/7/8.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON


class CVListTableViewController: UITableViewController {

    
    let cvListCell = "CVListTableViewCell"
    var cvInfos = [CvInfo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackButton()
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.registerNib(UINib(nibName: "CVListTableViewCell", bundle: nil), forCellReuseIdentifier: cvListCell)
        
        HUD.show(.RotatingImage(loadingImage))
        let seedUrl = getApplicantListForMyInterview
        let parameters = ["interviewId":30251854]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseCvList)
        
    }
    
    func praseCvList(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            let cvData = json["data"].array!
            if cvData.count > 0{
                for index in 0...cvData.count - 1{
                    let cvInfo = CvInfo()
                    cvInfo.getCvInfo(cvData[index])
                    self.cvInfos.append(cvInfo)
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
        
//        let positionDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PositionDetailViewController") as! PositionDetailViewController
//        
//        positionDetailViewController.jobid = self.jobs[indexPath.row].jobid!
//        positionDetailViewController.delegate = self
//        
//        self.currentIndexPath = indexPath
//        self.currentJob = self.jobs[indexPath.row]
//        
//        self.navigationController?.pushViewController(positionDetailViewController, animated: true)
    }
    
    
    
    
    
}
