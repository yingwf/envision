//
//  PositionDetailViewController.swift
//  envision
//
//  Created by  ywf on 16/6/1.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON

class PositionDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var shareBtn: UIView!
    
    var webSite: String = ""
    var job = Job()
    var jobid = 0


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    
    
    let jotTitleTableViewCell = "JotTitleTableViewCell"
    let jobInfoTableViewCell = "JobInfoTableViewCell"

    var shareView = YYShareView()
    var delegate: updateRowInfoDelegate?
    
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
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight =  UITableViewAutomaticDimension

        self.tableView.registerNib(UINib(nibName: "JotTitleTableViewCell", bundle: nil), forCellReuseIdentifier: jotTitleTableViewCell)
        self.tableView.registerNib(UINib(nibName: "JobInfoTableViewCell", bundle: nil), forCellReuseIdentifier: jobInfoTableViewCell)

        let seedUrl = getjobInfoJson
        var parameters = ["jobId":jobid] as! [String: AnyObject]
        if userinfo.beisen_id != nil{
            parameters["applicantId"] = userinfo.beisen_id!
        }
        afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseJob)
        
        self.tableView.separatorStyle = .None

        
        HUD.show(.RotatingImage(loadingImage))
        
        shareBtn.userInteractionEnabled = true
        shareBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "shareAction"))
        
        self.setBackButton()

        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    

    func praseJob(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            self.job.getJobInfo(json)
            self.tableView.reloadData()
        }
        HUD.hide()
    }
    
    func shareAction(){
        guard let jobid = self.job.jobid else{
            return
        }
        shareView.vc = self
        shareView.job = self.job
        shareView.webpageUrl = getjobInfoUrl + "?jobId=\(jobid)"
        shareView.show()
        
    }
    
    
    @IBAction func applyJob(sender: AnyObject) {
        
        if userinfo.id == nil{
            //未登录时，提醒登录
            let loginViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            return
        }
        if !userinfo.haveCV(){
            //未填写微简历
            let editCVViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("EditCVViewController") as! EditCVViewController
            editCVViewController.isModify = true
            self.navigationController?.pushViewController(editCVViewController, animated: true)
            return
        }
        
        if userinfo.type != 1 && userinfo.type != 2{
            let alertView = UIAlertController(title: "提醒", message: "只有学生可以申请职位", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            return
        }
        
        let sendViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("SendViewController") as! SendViewController
        sendViewController.job = self.job
        self.navigationController?.pushViewController(sendViewController, animated: true)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func collectTap(sender: UITapGestureRecognizer){

        //未登录时提示登录
        if userinfo.id == nil{
            //未登录时，提醒登录
            let loginViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            return
        }
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! JotTitleTableViewCell
        
        if self.job.isCollect != nil && !self.job.isCollect! {
            cell.collectImage.image = UIImage(named: "collected")

            let seedUrl = favorJob
            let parameters = ["applicantId":userinfo.beisen_id!, "jobId":self.jobid ] as! [String: AnyObject]
            afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseFavor)
            
        }else{
            cell.collectImage.image = UIImage(named: "uncollected")
            let seedUrl = unFavorJob
            let parameters = ["applicantId":userinfo.beisen_id!, "jobId":self.jobid ] as! [String: AnyObject]
            afRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseUnFavor)
        }
    }
    
    func praseFavor(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            self.job.isCollect = true
            self.delegate?.updateRowInfo(self.job)
        }else{
            if json["message"].string == "您已收藏该职位"{
                return
            }
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! JotTitleTableViewCell
            cell.collectImage.image = UIImage(named: "uncollected")
            let alertView = UIAlertController(title: "提醒", message: "网络异常，请重新操作", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }
        
    }
    
    func praseUnFavor(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            self.job.isCollect = false
            self.delegate?.updateRowInfo(self.job)
        }else{
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! JotTitleTableViewCell
            cell.collectImage.image = UIImage(named: "collected")
            let alertView = UIAlertController(title: "提醒", message: "网络异常，请重新操作", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(jotTitleTableViewCell, forIndexPath: indexPath) as! JotTitleTableViewCell
            cell.jobTitle.text = self.job.jobTitle
            cell.address.text = self.job.address
            cell.address.sizeToFit()
            cell.kind.text = self.job.kind
            cell.major.text = self.job.MXRQ
            
            if userinfo.type != 3 {
                cell.collectImage.hidden = false
                
                if self.job.isCollect != nil && self.job.isCollect! {
                    cell.collectImage.image = UIImage(named: "collected")
                }else{
                    cell.collectImage.image = UIImage(named: "uncollected")
                }
                cell.collectImage.userInteractionEnabled = true
                let collectTap = UITapGestureRecognizer(target: self, action: "collectTap:")
                cell.collectImage.addGestureRecognizer(collectTap)
            }else {
                cell.collectImage.hidden = true
            }

            
            //添加种子图片
            let width = cell.contentView.frame.width - 32
            var count = Int(width/70)
            if count > self.job.seedList.count{
                count = self.job.seedList.count
            }
            
            if count > 0{
                for index in 0...count - 1{
                    let imageView = UIImageView(frame: CGRect(x: 16 + index * 70, y: 103, width: 60, height: 60))
                    imageView.imageFromUrl(self.job.seedList[index].image)
                    imageView.layer.cornerRadius = 3
                    imageView.layer.masksToBounds = true
                    imageView.userInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: "tapSeedImage:")
                    imageView.addGestureRecognizer(tap)
                    tap.view?.tag = index
                    cell.contentView.addSubview(imageView)
                }
            }
            
            returnCell = cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(jobInfoTableViewCell, forIndexPath: indexPath) as! JobInfoTableViewCell
            cell.title.text = "工作内容"
            cell.content.text = self.job.Duty
            returnCell = cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier(jobInfoTableViewCell, forIndexPath: indexPath) as! JobInfoTableViewCell
            cell.title.text = "职位要求"
            cell.content.text = self.job.Requiremnet
            returnCell = cell
        }
        returnCell.selectionStyle = .None
        return returnCell
    }
    
    func tapSeedImage(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        if tag != nil && tag <= self.job.seedList.count - 1{
            let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            introViewController.navigationItem.title = "种子成长故事"
            introViewController.webSite = getSeed + "?id=\(self.job.seedList[tag!].id!)"
            
            self.navigationController?.pushViewController(introViewController, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let width = UIScreen.mainScreen().bounds.width
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 10))
        sectionView.backgroundColor = BACKGROUNDCOLOR
        if section == 2{
            sectionView.backgroundColor = UIColor.clearColor()
        }
        
        return sectionView
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
