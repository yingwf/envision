//
//  TimeSelectTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class TimeSelectTableViewController: UITableViewController {

    let timeTitleTableViewCell = "TimeTitleTableViewCell"
    let timeSelectTableViewCell = "TimeSelectTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "TimeSelectTableViewCell", bundle: nil), forCellReuseIdentifier: timeSelectTableViewCell)
        self.tableView.registerNib(UINib(nibName: "TimeTitleTableViewCell", bundle: nil), forCellReuseIdentifier: timeTitleTableViewCell)
        
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
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var returnCell = UITableViewCell()
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(timeTitleTableViewCell, forIndexPath: indexPath) as! TimeTitleTableViewCell
            
            returnCell = cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(timeSelectTableViewCell, forIndexPath: indexPath) as! TimeSelectTableViewCell
            cell.selectButton.addTarget(self, action: "selectTimeOK:", forControlEvents: .TouchUpInside)
            
            
            returnCell = cell
        }
        
        returnCell.selectionStyle = .None

        return returnCell
    }
    
    func selectTimeOK(sender: UIButton){
        
        let alertView = UIAlertController(title: "确认选择", message: "选择该时间段作为面试时间，不可更改", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确认", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: false, completion: nil)
        
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
