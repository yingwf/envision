//
//  TimeSelectTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON


class TimeSelectTableViewController: UITableViewController {

    let timeTitleTableViewCell = "TimeTitleTableViewCell"
    let timeSelectTableViewCell = "TimeSelectTableViewCell"
    
    var interviewInfos = [InterviewInfo]()
    var delegate: UpdateInterviewInfoDelegate?
    var currentRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "TimeSelectTableViewCell", bundle: nil), forCellReuseIdentifier: timeSelectTableViewCell)
        self.tableView.registerNib(UINib(nibName: "TimeTitleTableViewCell", bundle: nil), forCellReuseIdentifier: timeTitleTableViewCell)
        self.setBackButton()
        
        HUD.show(.RotatingImage(loadingImage))
        
        let seedUrl = getInterviewInfoList
        var parameters = ["applicantId":userinfo.beisen_id! ] as! [String: AnyObject]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseInterviewInfoList)
    }
    
    func praseInterviewInfoList(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            let interviewList = json["list"].array!
            if interviewList.count > 0{
                for index in 0...interviewList.count - 1{
                    let interview = InterviewInfo()
                    interview.getInterviewInfo(interviewList[index])
                    self.interviewInfos.append(interview)
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
        return interviewInfos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var returnCell = UITableViewCell()
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(timeTitleTableViewCell, forIndexPath: indexPath) as! TimeTitleTableViewCell
            
            returnCell = cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(timeSelectTableViewCell, forIndexPath: indexPath) as! TimeSelectTableViewCell
            cell.selectAddress.text = interviewInfos[indexPath.row - 1].location!
            cell.selectPeople.text = "已有\(interviewInfos[indexPath.row - 1].number!)/\(interviewInfos[indexPath.row - 1].allNumber!)人"
            cell.selectTime.text = interviewInfos[indexPath.row - 1].getInterViewTime()
            if interviewInfos[indexPath.row - 1].number! == interviewInfos[indexPath.row - 1].allNumber!{
                //已满
                cell.selectButton.enabled = false
                cell.selectButton.backgroundColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)

            }else{
                cell.selectButton.enabled = true
                cell.selectButton.backgroundColor = SYSTEMCOLOR
                cell.selectButton.tag = indexPath.row
                cell.selectButton.addTarget(self, action: "selectTimeOK:", forControlEvents: .TouchUpInside)
            }
            
            cell.selectPeople.sizeToFit()
            
            returnCell = cell
        }
        
        returnCell.selectionStyle = .None

        return returnCell
    }
    
    
    func selectTimeOK(sender: UIButton){
        self.currentRow = sender.tag - 1
        let alertView = UIAlertController(title: "确认选择", message: "选择该时间段作为面试时间，不可更改", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确认", style: .Default){
            (action) in
            HUD.show(.RotatingImage(loadingImage))

            
            let seedUrl = selectInterviewTime
            let parameters = ["applicantId":userinfo.beisen_id!,"scheduleInterviewid":self.interviewInfos[self.currentRow].id! ]
            doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: self.praseSelectInterviewTime)
            

        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)

        alertView.addAction(okAction)
        alertView.addAction(cancelAction)
        self.presentViewController(alertView, animated: false, completion: nil)
        
    }
    
    func praseSelectInterviewTime(json: SwiftyJSON.JSON){

        if json["success"].boolValue {
            self.delegate?.updateInterviewTime(self.interviewInfos[self.currentRow])
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            var message = "提交失败，请重新提交"
            if json["message"].string != nil{
                message = json["message"].string!
            }
            let alertView = UIAlertController(title: "提醒", message:message , preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确认", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
        HUD.hide()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        
        if indexPath.row == 0{
            rowHeight = 44
        }else{
            rowHeight = 66
        }
        
        return rowHeight
    }
    
    @IBAction func giveup(sender: AnyObject) {
        
        let endInterviewTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EndInterviewTableViewController") as! EndInterviewTableViewController
        
        self.navigationController?.pushViewController(endInterviewTableViewController, animated: true)
        
        
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
