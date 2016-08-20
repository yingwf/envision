//
//  MyTableViewController.swift
//  envision
//
//  Created by  ywf on 16/5/26.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyTableViewController: UITableViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    let studentIcon = ["center1","center2","center3","center4","center5"]
    let interviewIcon = ["ic_icon","ic_icon1","ic_icon2","ic_icon3","ic_icon4"]

    let defaultTitle = ["联系我们"]
    let studentTitle = ["我的应聘","收藏职位","我的简历","我的消息","联系我们"]
    let interviewTitle = ["校园行程","我的面试","我的报表","校招工作组","帮助中心"]
    
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
        self.tableView.reloadData()
        
    }

    func autoLogin(){
        let login = NSUserDefaults.standardUserDefaults().valueForKey("login") as? Bool
        
        if (login != nil) && login! {
            let username = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
            let password = NSUserDefaults.standardUserDefaults().valueForKey("password") as? String
            
            if username == nil || password == nil{
                return
            }
            
            let url = LOGIN
            let param = ["id": username! , "password":password! , "deviceId":deviceId!, "phoneType":2 ] as [String : AnyObject]
            afRequest(url, parameters: param, encoding:.URL, praseMethod: praseLogin)
        }
    }
    
    
    func praseLogin(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            userinfo.getUserInfo(json)
            myTableViewController?.updateUserInfo()
            
            if LAUNCH && (userinfo.type == 1 || userinfo.type == 2) {
                //学生身份，打开我的应聘
                LAUNCH = false
                homeViewController?.selectedIndex = 2
                myApplyTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyApplyTableViewController") as? MyApplyTableViewController
                self.navigationController?.pushViewController(myApplyTableViewController!, animated: true)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSection = 6
        if userType == nil{
            return numberOfSection
        }
        switch userType!{
        case 1: //学生
            numberOfSection = 6
        case 2: //老师
            numberOfSection = 6
        case 3: //面试官
            numberOfSection = 6
        default:
            numberOfSection = 6
        }
        return numberOfSection
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if userType == 1 || userType == 2 || userType == nil{
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
        
        if self.userType == nil{
            //未登录
            switch(indexPath.section){
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(headerCell, forIndexPath: indexPath) as! HeaderTableViewCell
                
                logoutButton.hidden = true
                
                cell.name.hidden = true
                cell.dreamerID.hidden = true
                cell.toLogin.hidden = false
                cell.headImage.image = UIImage(named: "head")
                
                cell.accessoryType = .None
                cell.selectionStyle = .Default
                returnCell = cell
            case 1...4:
                let cell = tableView.dequeueReusableCellWithIdentifier(centerCell, forIndexPath: indexPath) as! CenterTableViewCell
                cell.centerImage.image = UIImage(named: self.studentIcon[indexPath.section - 1])
                cell.centerTitle.text = self.studentTitle[indexPath.section - 1]
                cell.accessoryType = .DisclosureIndicator
                returnCell = cell
            case 5:
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
                
            default:
                print("default")
            }

        }else{
            switch(self.userType!, indexPath.section){
            case(1...3, 0):
                let cell = tableView.dequeueReusableCellWithIdentifier(headerCell, forIndexPath: indexPath) as! HeaderTableViewCell
                
                logoutButton.hidden = false
                
                cell.name.hidden = false
                cell.dreamerID.hidden = false
                cell.toLogin.hidden = true
                
                cell.headImage.imageFromUrl(userinfo.image)
                cell.name.text = userinfo.name
                
                if self.userType == 1 || self.userType == 2{
                    cell.dreamerID.text = "偏执狂ID：\(userinfo.beisen_id!)"
                }else{
                    cell.dreamerID.text = "Email：\(userinfo.email!)"
                }
                cell.selectionStyle = .None
                returnCell = cell
            case(1...2, 1...4):
                //学生、老师
                let cell = tableView.dequeueReusableCellWithIdentifier(centerCell, forIndexPath: indexPath) as! CenterTableViewCell
                cell.centerImage.image = UIImage(named: self.studentIcon[indexPath.section - 1])
                cell.centerTitle.text = self.studentTitle[indexPath.section - 1]
                cell.accessoryType = .DisclosureIndicator
                if BADGE > 0 && indexPath.section == 4 {
                    cell.messageHint.hidden = false
                }                
                returnCell = cell
            case(3, 1...5):
                //面试官
                let cell = tableView.dequeueReusableCellWithIdentifier(centerCell, forIndexPath: indexPath) as! CenterTableViewCell
                cell.centerImage.image = UIImage(named: self.interviewIcon[indexPath.section - 1])
                cell.centerTitle.text = self.interviewTitle[indexPath.section - 1]
                cell.accessoryType = .DisclosureIndicator
                returnCell = cell
            case(1...2, 5):
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
            default:
                print("default")
            }
        }
        
        return returnCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        
        if indexPath.section == 0 {
            rowHeight = 85
        }else if indexPath.section >= 1 && indexPath.section <= 4 {
            rowHeight = 44
        }else if indexPath.section == 5{
            if self.userType == 3{
                //面试官
                rowHeight = 44
            }else{
                //学生，老师，或未登录
                if indexPath.row == 0 {
                    rowHeight = 44
                }else if indexPath.row == 1{
                    rowHeight = 60
                }
            }
        }
        
        return rowHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 10
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        if (userType != 3 && section == 5)  {
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
        
        if userType == 1 || userType == 2{
            switch indexPath.section {
//            case 0:
//                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//                
//                self.navigationController?.pushViewController(loginViewController, animated: true)
            case 1:
                //我的应聘
                myApplyTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyApplyTableViewController") as? MyApplyTableViewController
                
                self.navigationController?.pushViewController(myApplyTableViewController!, animated: true)
            case 2:
                //收藏职位
                let collectedJobsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CollectedJobsViewController") as! CollectedJobsViewController

                self.navigationController?.pushViewController(collectedJobsViewController, animated: true)
                
            case 3:
                let cvViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyCVViewController") as! MyCVViewController
                
                self.navigationController?.pushViewController(cvViewController, animated: true)
            case 4:
                //我的消息
                let messageTableViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("MessageTableViewController") as! MessageTableViewController
                self.navigationController?.pushViewController(messageTableViewController, animated: true)
            default:
                print("default")

            }
            
            
        }else if userType == 3{
            switch indexPath.section{
//            case 0:
//                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//                
//                self.navigationController?.pushViewController(loginViewController, animated: true)
            case 2:
                let interViewTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InterViewTableViewController") as! InterViewTableViewController
                
                self.navigationController?.pushViewController(interViewTableViewController, animated: true)
            case 4:
                
                let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
                introViewController.webSite = workingGroup
                introViewController.navigationItem.title = "校招工作组"
                self.navigationController?.pushViewController(introViewController, animated: true)
                
            case 5:
                let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
                introViewController.webSite = helpUrl
                introViewController.navigationItem.title = "帮助中心"
                self.navigationController?.pushViewController(introViewController, animated: true)
                
            default:
                print("default")
            }
            
        }else {
            //未登录
            switch indexPath.section{
            case 0...4:
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                
                self.navigationController?.pushViewController(loginViewController, animated: true)
            default:
                print("default")
                
            }

        }
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func setMessageHint(haveMessage: Bool) {
        guard userType == 1 || userType == 2 else {
            return
        }
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 4)) as! CenterTableViewCell
        cell.messageHint.hidden = !haveMessage
        
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "login")//标识自动登录
        userinfo = UserInfo()
        self.updateUserInfo()
        
        BADGE = 0
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        homeViewController?.tabBar.items?.last?.badgeValue = nil

    }
}
