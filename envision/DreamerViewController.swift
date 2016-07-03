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

class DreamerViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    let homeCell = "HomeTableViewCell"
    let iconCell = "IconTableViewCell"
    
    let headView = YYScrollView()
    var seedArray = [SeedInfo]()
    var seedImageArray = [UIImageView]()
    var seedRowHeight:CGFloat = 0
    var imagePickerController: YJImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...11 {
            let imageView = UIImageView(frame: CGRectZero)
            imageView.contentMode = .ScaleToFill
            seedImageArray.append(imageView) //UIImageView(frame: CGRectZero)
        }
        
        //获取滚动图片
        let url = GET_MARQUESS
        doRequest(url, parameters: nil, encoding: .JSON, praseMethod: praseMarquess)
        self.tableView.tableHeaderView = headView
        
        let seedUrl = getSeedList
        doRequest(seedUrl, parameters: nil, encoding: .JSON, praseMethod: praseSeedList)
        
        
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
            let count = json["marqueeList"].array!.count
            var imageArray = [String]()
            
            for index in 0 ... count - 1 {
                let url = json["marqueeList"].array![index].string!
                imageArray.append(url)
            }
            self.headView.delegate = self
            self.headView.initWithImgs(imageArray)
            
        }
    }
    
    //获取种子信息
    func praseSeedList(json: SwiftyJSON.JSON){
        let status = json["success"].boolValue
        if status {
            let count = json["seedList"].array!.count
            
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
        //录制视频
        imagePickerController = YJImagePickerController()
        imagePickerController!.delegate = self
        self.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imagePickerController?.saveVideo(info)
    }
    
    func applyPosition(){
        //self.navigationController?.tabBarController?.selectedIndex = 1
        let applyViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ApplyTableViewController") as! ApplyTableViewController
        self.navigationController?.pushViewController(applyViewController, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(iconCell, forIndexPath: indexPath) as! IconTableViewCell
            
            //成为梦想偏执狂，职位申请
            cell.applyView.userInteractionEnabled = true
            let applyTap = UITapGestureRecognizer(target: self, action: "applyPosition")
            cell.applyView.addGestureRecognizer(applyTap)
            
            
            //视频录制
            cell.recordVideoView.userInteractionEnabled = true
            let videoTap = UITapGestureRecognizer(target: self, action: "recordVideo")
            cell.recordVideoView.addGestureRecognizer(videoTap)
            
//            let arrowWidth = 11.0
//            let arrowHeight = 7.0
//            let arrowY = 8.5
//            UIView.animateWithDuration(0.8,
//                delay:0.5,
//                usingSpringWithDamping: 0.8,
//                initialSpringVelocity: 0.3,
//                options: [.Repeat,.CurveEaseInOut],
//                animations: {
//                    cell.leftArrow.frame = CGRect(x: 40 + 5, y: arrowY, width: arrowWidth, height: arrowHeight)
//                },
//                completion: nil)
//            
//            UIView.animateWithDuration(0.8,
//                delay:0.5,
//                usingSpringWithDamping: 0.8,
//                initialSpringVelocity: 0.3,
//                options: [.Repeat,.CurveEaseInOut],
//                animations: {
//                    cell.rightArrow.frame = CGRect(x: 115 - 5, y: arrowY, width: arrowWidth, height: arrowHeight)
//                },
//                completion: nil)
//            UIView.animateWithDuration(0.8,
//                delay:0.5,
//                usingSpringWithDamping: 0.8,
//                initialSpringVelocity: 0.3,
//                options: [.Repeat,.CurveEaseInOut],
//                animations: {
//                    cell.leftArrow2.frame = CGRect(x: 40 + 5, y: arrowY, width: arrowWidth, height: arrowHeight)
//                },
//                completion: nil)
//            
//            UIView.animateWithDuration(0.8,
//                delay:0.5,
//                usingSpringWithDamping: 0.8,
//                initialSpringVelocity: 0.3,
//                options: [.Repeat,.CurveEaseInOut],
//                animations: {
//                    cell.rightArrow2.frame = CGRect(x: 115 - 5, y: arrowY, width: arrowWidth, height: arrowHeight)
//                },
//                completion: nil)
            
            
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
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//        let width = UIScreen.mainScreen().bounds.width
//        let headView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 10))
//        headView.backgroundColor = UIColor(red: 0xf7/255, green: 0xf7/255, blue: 0xf7/255, alpha: 1)
//        return headView
//    }
    
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
