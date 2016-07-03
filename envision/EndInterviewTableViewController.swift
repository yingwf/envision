//
//  EndInterviewTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class EndInterviewTableViewController: UITableViewController {

    let evaluateTableViewCell = "EvaluateTableViewCell"
    let resultTableViewCell = "ResultTableViewCell"
    let titleArray = ["您今日的战绩如下","请为今日面试安排做出评价","其他改进建议"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "EvaluateTableViewCell", bundle: nil), forCellReuseIdentifier: evaluateTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: resultTableViewCell)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var returnCell = UITableViewCell()
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(resultTableViewCell, forIndexPath: indexPath) as! ResultTableViewCell
            
            returnCell = cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(evaluateTableViewCell, forIndexPath: indexPath) as! EvaluateTableViewCell
            
            returnCell = cell
        }else if indexPath.section == 2{
            
            let width = UIScreen.mainScreen().bounds.width
            let textField = UITextView(frame: CGRect(x: 15, y: 0, width: width - 30, height: 150))
            textField.backgroundColor = BACKGROUNDCOLOR
            textField.layer.cornerRadius = 5
            textField.layer.masksToBounds = true
            returnCell.addSubview(textField)
            
        }
        
        returnCell.selectionStyle = .None
        
        return returnCell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        
        if indexPath.section == 0{
            rowHeight = 130
        }else if indexPath.section == 1{
            rowHeight = 160
        }else if indexPath.section == 2{
            rowHeight = 150
        }
        
        return rowHeight
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
//        
//        let sepView2 = UIView(frame: CGRect(x: 0, y: 43.5, width: width, height: 0.5))
//        sepView2.backgroundColor = SEPERATORCOLOR
//        sectionView.addSubview(sepView2)
        
        //色块view
        let decorateView = UIView(frame: CGRect(x: 0, y: 16, width: 3, height: 12))
        decorateView.backgroundColor = SYSTEMCOLOR
        sectionView.addSubview(decorateView)
        let sectionLabel = UILabel(frame: CGRect(x: 16, y: 16, width: width - 50, height: 14))
        sectionLabel.text = self.titleArray[section]
        sectionLabel.textColor = UIColor(red: 0x64/255, green: 0x64/255, blue: 0x64/255, alpha: 1)
        sectionLabel.font = UIFont.boldSystemFontOfSize(14)
        sectionView.addSubview(sectionLabel)
        
        return sectionView
        
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
