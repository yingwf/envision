//
//  ApplyTableViewController.swift
//  envision
//
//  Created by  ywf on 16/5/26.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class ApplyTableViewController: UITableViewController {
    
    let smallIcon = ["icon1","icon2","icon3"]
    let bigIcon   = ["icon4","icon5","icon6"]
    let positionTitle = ["2017届应届生","种子实习生","日常实习生"]
    let introduction = ["在校园我们欠缺经验，无实际工作体验，那这里就是你的梦想练级场。","2018届毕业生专属职位，帮助你的实习获得宝贵的工作经验。","积累工作经验要从基础做起，为您推荐更多职位。"]
    
    let positionTypeCell = "PositionTypeTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "PositionTypeTableViewCell", bundle: nil), forCellReuseIdentifier: positionTypeCell)

        

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
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = UITableViewCell()
            let width = UIScreen.mainScreen().bounds.width
            let headView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 10))
            headView.backgroundColor = BACKGROUNDCOLOR
            cell.contentView.addSubview(headView)
            cell.selectionStyle = .None
            return cell
            
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(positionTypeCell, forIndexPath: indexPath) as! PositionTypeTableViewCell
        
        cell.smallIcon.image = UIImage(named: smallIcon[indexPath.section])
        cell.bigIcon.image = UIImage(named: bigIcon[indexPath.section])
        cell.title.text = positionTitle[indexPath.section]
        cell.introduction.text = introduction[indexPath.section]

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 10
        }
        return 100
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let positionListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PositionListTableViewController") as! PositionListTableViewController
        
        self.navigationController?.pushViewController(positionListViewController, animated: true)
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
