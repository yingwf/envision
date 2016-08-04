//
//  MyCVViewController.swift
//  envision
//
//  Created by  ywf on 16/6/7.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit


class MyCVViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,RefreshUserInfoDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let cvCell = "CVTableViewCell"
    let cvEditCell = "EditCVTableViewCell"
    let sectionTitle = ["真实姓名","身份证号","电子邮箱","手机号码","性别","最高学历","毕业学校","专业名称","毕业年份"]
    let sectionImage = ["cv_name","Identity","cv_Email","cv_phone","cv_gender","cv_education","cv_school","cv_specialty","cv_graduate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        
        self.tableView.registerNib(UINib(nibName: "CVTableViewCell", bundle: nil), forCellReuseIdentifier: cvCell)
        
        self.tableView.registerNib(UINib(nibName: "EditCVTableViewCell", bundle: nil), forCellReuseIdentifier: cvEditCell)

        self.setBackButton()
    }

    func refreshUserInfo(){
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 4
        }
        return 6
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cvCell, forIndexPath: indexPath) as! CVTableViewCell
            cell.viewImage.image = UIImage(named: self.sectionImage[indexPath.row])
            cell.title.text = self.sectionTitle[indexPath.row]
            
            switch indexPath.row {
            case 0:
                cell.value.text = userinfo.name
            case 1:
                cell.value.text = userinfo.identity
            case 2:
                cell.value.text = userinfo.email
            case 3:
                cell.value.text = userinfo.mobile
            default:
                print("default")
            }
            
            
            returnCell = cell
        }else if (indexPath.section == 1) && (indexPath.row <= 4) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cvCell, forIndexPath: indexPath) as! CVTableViewCell
            cell.viewImage.image = UIImage(named: self.sectionImage[indexPath.row + 4])
            cell.title.text = self.sectionTitle[indexPath.row + 4]
            
            switch indexPath.row {
            case 0:
                cell.value.text = userinfo.gender
            case 1:
                cell.value.text = userinfo.educationLevel
            case 2:
                cell.value.text = userinfo.lastschool
            case 3:
                cell.value.text = userinfo.lastDisciplineKind
            case 4:
                cell.value.text = userinfo.graduationDate
            default:
                print("default")
            }
            
            returnCell = cell
        }else if(indexPath.section == 1) && (indexPath.row == 5) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cvEditCell, forIndexPath: indexPath) as! EditCVTableViewCell
//            let tap = UITapGestureRecognizer(target: self, action: "editCV")
//            cell.contentView.userInteractionEnabled = true
//            cell.contentView.addGestureRecognizer(tap)
            cell.editButton.addTarget(self, action: "editCV:", forControlEvents: .TouchUpInside)
            returnCell = cell
        }
        
        return returnCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let width = UIScreen.mainScreen().bounds.width
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 10))
        sectionView.backgroundColor = UIColor.clearColor()
        
        return sectionView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.row == 0{
//            let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
//            
//            self.navigationController?.pushViewController(loginViewController, animated: true)
//        }
    }
    
    func editCV(sender: UIButton){
        let editCVViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditCVViewController") as! EditCVViewController
        editCVViewController.isModify = true  //修改简历
        editCVViewController.delegate = self
        self.navigationController?.pushViewController(editCVViewController, animated: true)
        
    }

    @IBAction func fullResume(sender: AnyObject) {
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("FullResumeViewController") as! FullResumeViewController
        //introViewController.navigationItem.title = "详细简历"
        introViewController.webSite = fullresume + "?applicantId=\(userinfo.beisen_id!)"
        
        self.navigationController?.pushViewController(introViewController, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
