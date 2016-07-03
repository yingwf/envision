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
    
    let seeds = [["id": 12, "image": "http:/118.242.16.162:5580/envision/img/seed/head.png"],
        ["id" : 7,"image" : "http://118.242.16.162:5580/envision/img/seed/head1.jpg"],
        ["id" : 3,"image" : "http://118.242.16.162:5580/envision/img/seed/head2.jpg"]
        ]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    
    
    let jotTitleTableViewCell = "JotTitleTableViewCell"
    let jobInfoTableViewCell = "JobInfoTableViewCell"

    var shareView = YYShareView()
    
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
        let parameters = ["jobid":jobid] as! [String: AnyObject]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseJob)
        
        self.tableView.separatorStyle = .None

        
        HUD.show(.RotatingImage(loadingImage))
        
        shareBtn.userInteractionEnabled = true
        shareBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "shareAction"))
        
        //self.navigationItem.leftBarButtonItem = getBackButton(self)
        self.setBackButton()

        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
//    func backToPrevious(){
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    func praseJob(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            self.job.getJobInfo(json)
            self.tableView.reloadData()
        }
        HUD.hide()
    }
    
    func shareAction(){
        shareView.vc = self
        shareView.title = self.job.jobTitle!
        shareView.webpageUrl = self.webSite
        shareView.show()
        
    }
    
    
    @IBAction func applyJob(sender: AnyObject) {
        
        if userinfo.id == nil{
            //未登录时，提醒登录
            let loginViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginViewController, animated: true)
            return
        }
        
        let sendViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("SendViewController") as! SendViewController
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
        self.job.collected = !self.job.collected
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! JotTitleTableViewCell
        if self.job.collected {
            cell.collectImage.image = UIImage(named: "collected")
        }else{
            cell.collectImage.image = UIImage(named: "uncollected")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(jotTitleTableViewCell, forIndexPath: indexPath) as! JotTitleTableViewCell
            cell.jobTitle.text = self.job.jobTitle
            cell.address.text = self.job.location
            cell.address.sizeToFit()
            cell.kind.text = self.job.kind
            
            if self.job.collected {
                cell.collectImage.image = UIImage(named: "collected")
            }else{
                cell.collectImage.image = UIImage(named: "uncollected")
            }
            cell.collectImage.userInteractionEnabled = true
            let collectTap = UITapGestureRecognizer(target: self, action: "collectTap:")
            cell.collectImage.addGestureRecognizer(collectTap)
            
            
            //添加种子图片
            let width = cell.contentView.frame.width - 32
            var count = Int(width/70)
            if count > self.seeds.count{
                count = self.seeds.count
            }
            
            for index in 0...count - 1{
                let imageView = UIImageView(frame: CGRect(x: 16 + index * 70, y: 103, width: 60, height: 60))
                imageView.imageFromUrl(self.seeds[index]["image"] as! String)
                imageView.layer.cornerRadius = 3
                imageView.layer.masksToBounds = true
                imageView.userInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: "tapSeedImage:")
                imageView.addGestureRecognizer(tap)
                tap.view?.tag = index
                cell.contentView.addSubview(imageView)
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
        if tag != nil && tag <= self.seeds.count - 1{
            let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            introViewController.navigationItem.title = "种子成长故事"
            introViewController.webSite = getSeed + "?id=\(self.seeds[tag!]["id"] as! Int)"
            
            self.navigationController?.pushViewController(introViewController, animated: true)
            
        }
        
        
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 206
//    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
