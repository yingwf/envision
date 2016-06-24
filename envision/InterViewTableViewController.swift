//
//  InterViewTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/23.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class InterViewTableViewController: UITableViewController {
    let interviewCell = "InterviewTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "InterviewTableViewCell", bundle: nil), forCellReuseIdentifier: interviewCell)
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
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(interviewCell, forIndexPath: indexPath) as! InterviewTableViewCell
        cell.interview.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "beginInterview:")
        cell.interview.addGestureRecognizer(tap)
        tap.view?.tag = indexPath.row

        return cell
    }
    
    func beginInterview(tap: UITapGestureRecognizer){
        let beginInterviewTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BeginInterviewTableViewController") as! BeginInterviewTableViewController
        
        self.navigationController?.pushViewController(beginInterviewTableViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 166
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
