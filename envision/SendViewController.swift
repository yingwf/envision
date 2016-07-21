//
//  SendViewController.swift
//  envision
//
//  Created by  ywf on 16/7/1.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol RefreshUserInfoDelegate {
    
    func refreshUserInfo()
    
}

class SendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,RefreshUserInfoDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    var imagePickerController: YJImagePickerController?
    
    var job = Job()

    
    let sendTitleTableViewCell = "SendTitleTableViewCell"
    let sendContentTableViewCell = "SendContentTableViewCell"
    let sendVideoTableViewCell = "SendVideoTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let sepView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
        sepView.backgroundColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
        self.buttomView.addSubview(sepView)
        
        self.applyButton.layer.cornerRadius = 17
        self.applyButton.layer.masksToBounds = true
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        
        self.tableView.registerNib(UINib(nibName: "SendTitleTableViewCell", bundle: nil), forCellReuseIdentifier: sendTitleTableViewCell)
        self.tableView.registerNib(UINib(nibName: "SendContentTableViewCell", bundle: nil), forCellReuseIdentifier: sendContentTableViewCell)
        self.tableView.registerNib(UINib(nibName: "SendVideoTableViewCell", bundle: nil), forCellReuseIdentifier: sendVideoTableViewCell)

        
        self.tableView.separatorStyle = .None
        
        self.setBackButton()
    }
    
    
    @IBAction func applyJob(sender: AnyObject) {

        if userinfo.jobId != nil{
            //已申请职位
            let alertView = UIAlertController(title: "提醒", message: "职位已申请", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            return
        }
        
        
        
        let url = applyjob
        var parameters = ["applicantId":userinfo.beisen_id!, "jobId":self.job.jobid!] as! [String: AnyObject]

        HUD.show(.RotatingImage(loadingImage))

        doRequest(url, parameters: parameters, encoding: .URL, praseMethod: praseApplyJob)
        
    }
    
    func praseApplyJob(json: SwiftyJSON.JSON){
        HUD.hide()
        if json["success"].boolValue {
            userinfo.jobId = self.job.jobid
            
            let alertView = UIAlertController(title: "提醒", message: "申请职位成功", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){
                action in
                if isFromMyInterview {
                    //从我的应聘页面申请职位，回退到该页
                    isFromMyInterview = false
                    self.navigationController?.popToViewController(myApplyTableViewController!, animated: true)
                    myApplyTableViewController!.updateInfo() //更新信息
                    
                }else{
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }else{
            var message = "申请职位失败，请重新投递"
            if json["message"].string != nil{
                message = json["message"].string!
            }
            let alertView = UIAlertController(title: "提醒", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
    }
    
    
    func refreshUserInfo(){
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    func editCV(sender: UITapGestureRecognizer){
        
        let editCVViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditCVViewController") as! EditCVViewController
        editCVViewController.isModify = true
        editCVViewController.delegate = self
        
        self.navigationController?.pushViewController(editCVViewController, animated: true)
    }
    
    func recordVideo(){
        if !userinfo.haveCV(){
            //未填写微简历
            let editCVViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("EditCVViewController") as! EditCVViewController
            editCVViewController.isModify = true
            editCVViewController.delegate = self
            self.navigationController?.pushViewController(editCVViewController, animated: true)
            return
        }
        
        //录制视频
        imagePickerController = YJImagePickerController()
        imagePickerController!.delegate = self
        self.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(sendTitleTableViewCell, forIndexPath: indexPath) as! SendTitleTableViewCell
            
            cell.setInfo()

            cell.editView.userInteractionEnabled = true
            let collectTap = UITapGestureRecognizer(target: self, action: "editCV:")
            cell.editView.addGestureRecognizer(collectTap)
            
            returnCell = cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(sendContentTableViewCell, forIndexPath: indexPath) as! SendContentTableViewCell

            returnCell = cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier(sendVideoTableViewCell, forIndexPath: indexPath) as! SendVideoTableViewCell
            
            cell.record.userInteractionEnabled = true
            let recordTap = UITapGestureRecognizer(target: self, action: "recordVideo")
            cell.record.addGestureRecognizer(recordTap)
            returnCell = cell
        }
        returnCell.selectionStyle = .None
        return returnCell
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 165
        }
        return 168
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let width = UIScreen.mainScreen().bounds.width
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 10))
        sectionView.backgroundColor = BACKGROUNDCOLOR
        
        return sectionView
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
