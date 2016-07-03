//
//  MyTableViewController.swift
//  envision
//
//  Created by  ywf on 16/5/26.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    let studentIcon = ["center1","center2","center3","center4","center5"]
    let interviewIcon = ["center1","center2","center3","center4"]

    let defaultTitle = ["联系我们"]
    let studentTitle = ["我的应聘","收藏职位","我的简历","我的消息","联系我们"]
    let interviewTitle = ["校园行程","我的面试","校招工作组","帮助中心"]
    
    let headerCell = "HeaderTableViewCell"
    let centerCell = "CenterTableViewCell"
    let contactCell = "ContactTableViewCell"
    
    var userType: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: headerCell)
        self.tableView.registerNib(UINib(nibName: "CenterTableViewCell", bundle: nil), forCellReuseIdentifier: centerCell)
        self.tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: contactCell)
        
        
        if userinfo.id != nil{
            logoutButton.hidden = false
            userType = userinfo.type
        }else{
            logoutButton.hidden = true
        }
        
    }
    
    func updateUserInfo(){
        self.userType = userinfo.type
        
        //let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.reloadData()// ([indexPath], withRowAnimation: .None)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSection = 2
        if userType == nil{
            return numberOfSection
        }
        switch userType!{
        case 1: //学生
            numberOfSection = 6
        case 2: //老师
            numberOfSection = 6
        case 3: //面试官
            numberOfSection = 5
        default:
            numberOfSection = 2
        }
        return numberOfSection
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userType == nil{
            return 1
        }else if userType == 1 || userType == 2{
             //学生、老师
            if section == 5{
                return 2
            }
        }else if userType == 3{
            return 1
        }

        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if indexPath.section == 0 {
            
            
            //判断是否已登录
            if self.userType != nil{
                let cell = tableView.dequeueReusableCellWithIdentifier(headerCell, forIndexPath: indexPath) as! HeaderTableViewCell

                logoutButton.hidden = false
                
                cell.name.hidden = false
                cell.idLabel.hidden = false
                cell.dreamerID.hidden = false
                cell.toLogin.hidden = true
                
                cell.headImage.imageFromUrl(userinfo.image)
                cell.name.text = userinfo.name
                cell.dreamerID.text = String(userinfo.beisen_id!)
                returnCell = cell
            }else{
                
                returnCell.accessoryType = .None
                returnCell.selectionStyle = .None
            }
            
        }else if indexPath.section >= 1 && indexPath.section <= 4 {
            if self.userType == 1 || self.userType == 2{
                //学生、老师
                let cell = tableView.dequeueReusableCellWithIdentifier(centerCell, forIndexPath: indexPath) as! CenterTableViewCell
                cell.centerImage.image = UIImage(named: self.studentIcon[indexPath.section - 1])
                cell.centerTitle.text = self.studentTitle[indexPath.section - 1]
                cell.accessoryType = .DisclosureIndicator
                returnCell = cell
            }else if self.userType == 3{
                //面试官
                let cell = tableView.dequeueReusableCellWithIdentifier(centerCell, forIndexPath: indexPath) as! CenterTableViewCell
                cell.centerImage.image = UIImage(named: self.interviewIcon[indexPath.section - 1])
                cell.centerTitle.text = self.interviewTitle[indexPath.section - 1]
                cell.accessoryType = .DisclosureIndicator
                returnCell = cell
            }else{
                //未登录
                if indexPath.section == 1 {
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(headerCell, forIndexPath: indexPath) as! HeaderTableViewCell
                    
                    logoutButton.hidden = true
                    
                    cell.name.hidden = true
                    cell.idLabel.hidden = true
                    cell.dreamerID.hidden = true
                    cell.toLogin.hidden = false
                    
                    cell.accessoryType = .None
                    cell.selectionStyle = .None
                    returnCell = cell
                }
                
                
            }

        }else if indexPath.section == 5{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(centerCell, forIndexPath: indexPath) as! CenterTableViewCell
                cell.centerImage.image = UIImage(named: self.studentIcon[indexPath.section - 1])
                cell.centerTitle.text = self.studentTitle[indexPath.section - 1]
                cell.accessoryType = .None
                cell.selectionStyle = .None
                returnCell = cell
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCellWithIdentifier(contactCell, forIndexPath: indexPath) as! ContactTableViewCell
                cell.selectionStyle = .None
                returnCell = cell
            }
            
        }
        
        return returnCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        
        if userType == 1 || userType == 2 || userType == 3{
            if indexPath.section == 0 {
                rowHeight = 85
            }else if indexPath.section >= 1 && indexPath.section <= 4 {
                rowHeight = 44
            }else if indexPath.section == 5{
                if indexPath.row == 0 {
                    rowHeight = 44
                }else if indexPath.row == 1{
                    rowHeight = 60
                }
            }
        }else{
            if indexPath.section == 0 {
                //未登录，居中
                let height = self.view.frame.height
                rowHeight = height/2 - 99
            }else if indexPath.section == 1{
                rowHeight = 85

            }
        }
        
        return rowHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 10
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        if (section == 5)  { //|| (userType == nil && section == 1)
            let width = UIScreen.mainScreen().bounds.width
            let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 10))
            sectionView.backgroundColor = UIColor.clearColor()
            
            return sectionView
        }
        let width = UIScreen.mainScreen().bounds.width
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 10))
        sectionView.backgroundColor = BACKGROUNDCOLOR
        
        return sectionView
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if userType == 2{
            switch indexPath.section {
            case 0:
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                
                self.navigationController?.pushViewController(loginViewController, animated: true)
            case 1:
                //我的应聘
                let myApplyTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyApplyTableViewController") as! MyApplyTableViewController
                
                self.navigationController?.pushViewController(myApplyTableViewController, animated: true)
            case 2:
                //收藏职位
                let cvViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyCVViewController") as! MyCVViewController
                
                self.navigationController?.pushViewController(cvViewController, animated: true)
                
            case 3:
                let cvViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyCVViewController") as! MyCVViewController
                
                self.navigationController?.pushViewController(cvViewController, animated: true)
            case 4:
                //我的消息
                let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
                introViewController.webSite = mymessage
                introViewController.navigationItem.title = "我的消息"
                self.navigationController?.pushViewController(introViewController, animated: true)
                
            default:
                print("default")

            }
            
            
        }else if userType == 3{
            if indexPath.section == 0{
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                
                self.navigationController?.pushViewController(loginViewController, animated: true)
            }else if indexPath.section == 2{
                let interViewTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InterViewTableViewController") as! InterViewTableViewController
                
                self.navigationController?.pushViewController(interViewTableViewController, animated: true)
            }
            
            
        }else {
            //未登录
            if indexPath.section == 1{
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                
                self.navigationController?.pushViewController(loginViewController, animated: true)
            }
        }

    }
    
    @IBAction func logout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "login")//标识自动登录
        userinfo = UserInfo()
        self.updateUserInfo()

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
