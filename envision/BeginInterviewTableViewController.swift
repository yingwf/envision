//
//  BeginInterviewTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/24.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class BeginInterviewTableViewController: UITableViewController,updateInfoDelegate {

    let editTableCell = "BeginInterviewTableViewCell"
    let beginTableCell = "BeginInterviewButtonTableViewCell"
    
    let titleArray = ["面试官姓名","房间号","桌位号"]
    let placeholderArray = ["输入您的姓名","输入面试房间号码","输入面试桌位号"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 10))
        headView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.tableHeaderView = headView
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "BeginInterviewTableViewCell", bundle: nil), forCellReuseIdentifier: editTableCell)
        self.tableView.registerNib(UINib(nibName: "BeginInterviewButtonTableViewCell", bundle: nil), forCellReuseIdentifier: beginTableCell)

        
    }
    
    func updateInfo(indexPath: NSIndexPath, info: String?){
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! BeginInterviewTableViewCell
        
        cell.valueField.text = info
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section <= 2{
            let cell = tableView.dequeueReusableCellWithIdentifier(editTableCell, forIndexPath: indexPath) as! BeginInterviewTableViewCell

            cell.title.text = self.titleArray[indexPath.section]
            cell.valueField.placeholder = self.placeholderArray[indexPath.section]
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(beginTableCell, forIndexPath: indexPath) as! BeginInterviewButtonTableViewCell

        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section <= 2{
            return 44
        }
        return 64
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 10
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let width = UIScreen.mainScreen().bounds.width
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 10))
        sectionView.backgroundColor = UIColor.clearColor()
        
        return sectionView
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section <= 2{
            
            let inputInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InputInfoViewController") as! InputInfoViewController
            
            inputInfoViewController.navigationItem.title = self.titleArray[indexPath.section]
            
            inputInfoViewController.placeHolder = self.placeholderArray[indexPath.section]
            
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! BeginInterviewTableViewCell
            
            inputInfoViewController.originValue = cell.valueField.text
            
            inputInfoViewController.indexPath = indexPath
            
            inputInfoViewController.delegate = self
            
            self.navigationController?.pushViewController(inputInfoViewController, animated: true)
        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
