//
//  DreamerViewController.swift
//  envision
//
//  Created by  ywf on 16/5/26.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MediaPlayer

class DreamerViewController: UITableViewController {
    
    let homeCell = "HomeTableViewCell"
    let iconCell = "IconTableViewCell"
    
    let headView = YYScrollView()
    var seedArray = [SeedInfo]()
    var seedImageArray = [UIImageView]()
    var seedRowHeight:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...11 {
            let imageView = UIImageView(frame: CGRectZero)
            imageView.contentMode = .ScaleToFill
            seedImageArray.append(imageView)
        }
        
        //获取滚动图片
        let url = GET_MARQUESS
        afRequest(url, parameters: nil, encoding: .JSON, praseMethod: praseMarquess)
        self.tableView.tableHeaderView = headView
        
        let seedUrl = getSeedList
        afRequest(seedUrl, parameters: nil, encoding: .JSON, praseMethod: praseSeedList)
        
        
        let width = UIScreen.mainScreen().bounds.width

        self.tableView.separatorStyle = .None
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 340
        
        self.tableView.registerNib(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: homeCell)
        self.tableView.registerNib(UINib(nibName: "IconTableViewCell", bundle: nil), forCellReuseIdentifier: iconCell)

        headView.frame = CGRect(x: 0, y: 0, width: width, height: width*0.427) //160
        
        
    }

    //获取滚动图片
    func praseMarquess(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            if let marqueeList = json["marqueeList"].array {
                var imageArray = [String]()
                for index in 0 ..< marqueeList.count {
                    if let url = marqueeList[index]["marqueel"].string {
                        imageArray.append(url)
                    }
                }
                self.headView.delegate = self
                self.headView.initWithImgs(imageArray)
            }
            
        }
    }
    
    //获取种子信息
    func praseSeedList(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            guard let count = json["seedList"].array?.count else {
                return
            }
            guard count > 0 else {
                return
            }
            for index in 0 ... count - 1 {
                let seed = SeedInfo()
                seed.id = json["seedList"].array![index]["id"].int
                seed.content = json["seedList"].array![index]["content"].string
                seed.title = json["seedList"].array![index]["title"].string
                seed.school = json["seedList"].array![index]["school"].string
                seed.department = json["seedList"].array![index]["department"].string
                seed.name = json["seedList"].array![index]["name"].string
                seed.image = json["seedList"].array![index]["image"].string
                
                seedArray.append(seed)
                
                if index < self.seedImageArray.count && seed.image != nil && self.seedImageArray[index].image == nil{
                    self.seedImageArray[index].imageFromUrl(seed.image!)
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action: "tapSeed:")
                    self.seedImageArray[index].userInteractionEnabled = true
                    self.seedImageArray[index].addGestureRecognizer(tapGesture)
                    if self.seedArray[index].id != nil{
                        tapGesture.view?.tag = self.seedArray[index].id!
                    }
                    
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func recordVideo(){
        if userinfo.id == nil{
            //未登录时，提醒登录
            let loginViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            return
        }
        if userinfo.type == 3 {
            let alertView = UIAlertController(title: "提醒", message: "面试官用户不能录制视频", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler:nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            return
        }
        if !userinfo.haveCV(){
            //未填写微简历
            let alertView = UIAlertController(title: "提醒", message: "请先完善简历信息", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){
                (action) in
                let editCVViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("EditCVViewController") as! EditCVViewController
                editCVViewController.isModify = true
                self.navigationController?.pushViewController(editCVViewController, animated: true)
            }
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            alertView.addAction(okAction)
            alertView.addAction(cancelAction)
            self.presentViewController(alertView, animated: false, completion: nil)
            return
        }
        
        //判断是否已录制视频
        let seedUrl = getVideo
        let param = ["applicantId": userinfo.beisen_id!]
        afRequest(seedUrl, parameters: param, encoding: .URL, praseMethod: praseVideo)
        

    }
    
    func praseVideo(json: SwiftyJSON.JSON) {
        let status = json["success"].boolValue
        if status {
            if let url = json["Url"].string {
                //已录制
                let videoPlayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VideoPlayViewController") as! VideoPlayViewController
                videoPlayViewController.url = url
                self.navigationController?.pushViewController(videoPlayViewController, animated: true)
            } else {
                //未录制
                let videoRecordViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VideoRecordViewController") as! VideoRecordViewController
                self.navigationController?.pushViewController(videoRecordViewController, animated: true)
            }
        }
    }
    
    func applyPosition(){
        //self.navigationController?.tabBarController?.selectedIndex = 1
        let applyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ApplyTableViewController") as! ApplyTableViewController
        applyViewController.setButton = true
        self.navigationController?.pushViewController(applyViewController, animated: true)
        
    }
    
    func helpCenter(){
        
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        introViewController.webSite = helpUrl
        introViewController.navigationItem.title = "帮助中心"
        self.navigationController?.pushViewController(introViewController, animated: true)
    }
    
    func recommendAction(){
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        introViewController.webSite = recomparanoia
        introViewController.navigationItem.title = "推荐梦想偏执狂"
        self.navigationController?.pushViewController(introViewController, animated: true)
    }
    
    func gotoEnvision(){
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        introViewController.webSite = walktofuture
        introViewController.navigationItem.title = "走进远景"
        self.navigationController?.pushViewController(introViewController, animated: true)
    }
    
    func seedDepartment(){
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        introViewController.webSite = futureseed
        introViewController.navigationItem.title = "走进高校"
        self.navigationController?.pushViewController(introViewController, animated: true)
    }
    
    func jobCooperation(){
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        introViewController.webSite = employment
        introViewController.navigationItem.title = "就业合作"
        self.navigationController?.pushViewController(introViewController, animated: true)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(iconCell, forIndexPath: indexPath) as! IconTableViewCell
            
            //成为梦想偏执狂，职位申请
            cell.applyView.userInteractionEnabled = true
            let applyTap = UITapGestureRecognizer(target: self, action: "applyPosition")
            cell.applyView.addGestureRecognizer(applyTap)
            
            //推荐梦想偏执狂
            cell.recommendView.userInteractionEnabled = true
            let recommendTap = UITapGestureRecognizer(target: self, action: "recommendAction")
            cell.recommendView.addGestureRecognizer(recommendTap)
            
            //走进远景
            cell.gotoView.userInteractionEnabled = true
            let gotoTap = UITapGestureRecognizer(target: self, action: "gotoEnvision")
            cell.gotoView.addGestureRecognizer(gotoTap)
            
            //远景种子院
            cell.seedDpView.userInteractionEnabled = true
            let seedDpTap = UITapGestureRecognizer(target: self, action: "seedDepartment")
            cell.seedDpView.addGestureRecognizer(seedDpTap)
            
            //就业合作
            cell.coopView.userInteractionEnabled = true
            let coopTap = UITapGestureRecognizer(target: self, action: "jobCooperation")
            cell.coopView.addGestureRecognizer(coopTap)
            
            //视频录制
            cell.recordVideoView.userInteractionEnabled = true
            let videoTap = UITapGestureRecognizer(target: self, action: "recordVideo")
            cell.recordVideoView.addGestureRecognizer(videoTap)
            
            //帮助中心
            cell.helpView.userInteractionEnabled = true
            let helpTap = UITapGestureRecognizer(target: self, action: "helpCenter")
            cell.helpView.addGestureRecognizer(helpTap)

            
            returnCell = cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(homeCell, forIndexPath: indexPath) as! HomeTableViewCell
            cell.title.text = "关于远景"
            cell.aboutImage.image = UIImage(named: "banner_about")
            cell.aboutText.text = "远景能源是全球最大的智慧能源管理公司，业务包括智能硬件、软件和管理平台，目前管理着超过5000万千瓦的全球新能源资产，覆盖风电、光伏、充电网络、能效等领域。"
            
            //cell.more.userInteractionEnabled = true
            cell.contentView.userInteractionEnabled = true
            let moreTap = UITapGestureRecognizer(target: self, action: "moreAction")
            //cell.more.addGestureRecognizer(moreTap)
            cell.contentView.addGestureRecognizer(moreTap)
        
            returnCell = cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier(homeCell, forIndexPath: indexPath) as! HomeTableViewCell
            cell.title.text = "种子成长计划"
            cell.more.hidden = true
            cell.aboutImage.image = UIImage(named: "banner_seed")
            cell.aboutText.text = "远景60%的员工是每年从国内、海外各顶尖高校中招收的顶尖博士、硕士和本科生，这些心怀梦想，并兼具智慧、意志和爱为一身的年轻人，犹如一颗颗种子，在远景这个精神家园中发芽、成长。"
            returnCell = cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier(homeCell, forIndexPath: indexPath) as! HomeTableViewCell
            cell.title.text = "种子成长故事"
            cell.more.hidden = true
            cell.aboutText.hidden = true
            cell.aboutImage.hidden = true
            
            let screenWidth = UIScreen.mainScreen().bounds.width
            var imageSize = 75//图片长宽默认为75
            if (screenWidth - 52)/4 > 75 {
                imageSize = Int((screenWidth - 52)/4)
            }
            
            let imageSpace = 3 //图片之间的间隔
            let inSet = (screenWidth - CGFloat(imageSize * 4))/2.0 - 4.5 //图片inset
            var index = 0
            for row in 0...2{ //行
                for list in 0...3{  //列
                    let imageX = inSet + CGFloat((imageSize + imageSpace) * list)
                    let imageY = 64 + (imageSize + imageSpace) * row
                    self.seedImageArray[index].frame = CGRect(x: CGFloat(imageX), y: CGFloat(imageY), width: CGFloat(imageSize), height: CGFloat(imageSize))
                    
                    self.seedImageArray[index].contentMode = .ScaleToFill
                    
                    if index < self.seedArray.count && self.seedArray[index].image != nil {
                        self.seedImageArray[index].imageFromUrl(self.seedArray[index].image!)
                        
                        let tapGesture = UITapGestureRecognizer(target: self, action: "tapSeed:")
                        self.seedImageArray[index].userInteractionEnabled = true
                        self.seedImageArray[index].addGestureRecognizer(tapGesture)
                        if self.seedArray[index].id != nil{
                            tapGesture.view?.tag = self.seedArray[index].id!
                        }
                    }
                    
                    cell.contentView.addSubview(self.seedImageArray[index])
                    index++

                }
            }
            self.seedRowHeight = CGFloat(imageSize * 3) + 84
            
            returnCell = cell
        }
        
        return returnCell
    }
    
    func tapSeed(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        if tag == nil{
            return
        }
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        introViewController.navigationItem.title = "种子成长故事"
        introViewController.webSite = getSeed + "?id=\(tag!)"
        
        self.navigationController?.pushViewController(introViewController, animated: true)
        
    }
    
    func moreAction(){
        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        introViewController.webSite = envisioninfo
        introViewController.navigationItem.title = "关于远景"
        self.navigationController?.pushViewController(introViewController, animated: true)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        if indexPath.section == 0{
            rowHeight = 340
        }else if indexPath.section == 1{
            rowHeight = 290
        }else if indexPath.section == 2{
            rowHeight = 290
        }else if indexPath.section == 3{
            rowHeight = self.seedRowHeight //300
        }
        return rowHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
