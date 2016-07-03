//
//  PositionListTableViewController.swift
//  envision
//
//  Created by  ywf on 16/5/31.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON

class PositionListTableViewController: UITableViewController {
    
    let positionTitle = ["能源互联网软件类","智能风机与智慧风场研发类","智慧供应链类","智慧光伏类"]
    
    let positionListCell = "PositionListTableViewCell"
    
    var jobLists = [JobList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let leftBarBtn = UIBarButtonItem(title: "", style: .Plain, target: self,
//            action: "backToPrevious")
//        leftBarBtn.image = UIImage(named: "back")
//        leftBarBtn.tintColor = UIColor.whiteColor()
//        self.navigationItem.leftBarButtonItem = leftBarBtn
        
//        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
//        let backImage = UIImageView(frame: CGRect(x: -8, y: 5, width: 14, height: 22))
//        backImage.image = UIImage(named: "back")
//        backButton.addSubview(backImage)
//        backButton.addTarget(self, action: "backToPrevious", forControlEvents: .TouchUpInside)
//        let backItem = UIBarButtonItem(customView: backButton)
//        backItem.tintColor = UIColor.whiteColor()
        //self.navigationItem.leftBarButtonItem = getBackButton(self)
        self.setBackButton()

        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        //self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.registerNib(UINib(nibName: "PositionListTableViewCell", bundle: nil), forCellReuseIdentifier: positionListCell)
        
        HUD.show(.RotatingImage(loadingImage))
        let seedUrl = getJobList
        let parameters = ["Category":1] as! [String: AnyObject]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseJobList)
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
        let sepView1 = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
        sepView1.backgroundColor = SEPERATORCOLOR
        sectionView.addSubview(sepView1)

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
        
        let positionDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PositionDetailViewController") as! PositionDetailViewController
        
        positionDetailViewController.jobid = self.jobLists[indexPath.section].jobs[indexPath.row].jobid!//  getjobInfoUrl + "?jobid=\(self.jobLists[indexPath.section].jobs[indexPath.row].jobid!)"
        //positionDetailViewController.job = self.jobLists[indexPath.section].jobs[indexPath.row]
        
        self.navigationController?.pushViewController(positionDetailViewController, animated: true)
    }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
