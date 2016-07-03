//
//  MyApplyTableViewController.swift
//  envision
//
//  Created by  ywf on 16/6/27.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import AVFoundation

class MyApplyTableViewController: UITableViewController {

    let applyPosTableViewCell = "ApplyPosTableViewCell"
    let applyProTableViewCell = "ApplyProTableViewCell"
    let applyStatusTableViewCell = "ApplyStatusTableViewCell"
    let applyCVTableViewCell = "ApplyCVTableViewCell"
    let applyInterviewTableViewCell = "ApplyInterviewTableViewCell"
    let applyFinalTableViewCell = "ApplyFinalTableViewCell"
    let applyOfferTableViewCell = "ApplyOfferTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = UIColor(red: 0xf0/255, green: 0xfb/255, blue: 0xff/255, alpha: 1)
        self.tableView.separatorStyle = .None
        self.tableView.registerNib(UINib(nibName: "ApplyPosTableViewCell", bundle: nil), forCellReuseIdentifier: applyPosTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyProTableViewCell", bundle: nil), forCellReuseIdentifier: applyProTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyStatusTableViewCell", bundle: nil), forCellReuseIdentifier: applyStatusTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyCVTableViewCell", bundle: nil), forCellReuseIdentifier: applyCVTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyInterviewTableViewCell", bundle: nil), forCellReuseIdentifier: applyInterviewTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyFinalTableViewCell", bundle: nil), forCellReuseIdentifier: applyFinalTableViewCell)
        self.tableView.registerNib(UINib(nibName: "ApplyOfferTableViewCell", bundle: nil), forCellReuseIdentifier: applyOfferTableViewCell)

        self.setBackButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func capture(){
        
        let qrcodevc = SYQRCodeViewController()
        qrcodevc.SYQRCodeSuncessBlock = {(aqrvc:SYQRCodeViewController!, qrString:String!) -> Void in
            let alertView = UIAlertController(title: "二维码扫描结果", message: qrString, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
        qrcodevc.SYQRCodeFailBlock = {(aqrvc:SYQRCodeViewController!) -> Void in
            let alertView = UIAlertController(title: "二维码扫描结果", message: "扫描失败", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
        qrcodevc.SYQRCodeCancleBlock = {(aqrvc:SYQRCodeViewController!) -> Void in
            let alertView = UIAlertController(title: "二维码扫描结果", message: "扫描取消", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)
        }
        
        self.navigationController?.pushViewController(qrcodevc, animated: true)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var returnCell = UITableViewCell()
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyPosTableViewCell, forIndexPath: indexPath) as! ApplyPosTableViewCell

            returnCell = cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyProTableViewCell, forIndexPath: indexPath) as! ApplyProTableViewCell
            
            returnCell = cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyStatusTableViewCell, forIndexPath: indexPath) as! ApplyStatusTableViewCell
            //cell.setHide()
            
            returnCell = cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyCVTableViewCell, forIndexPath: indexPath) as! ApplyCVTableViewCell
            cell.setSelectTime()
            cell.selectButton.addTarget(self, action: "selectTime:", forControlEvents: .TouchUpInside)
            
            returnCell = cell
        }else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyInterviewTableViewCell, forIndexPath: indexPath) as! ApplyInterviewTableViewCell
            
            cell.capture.userInteractionEnabled = true
            let captureTap = UITapGestureRecognizer(target: self, action: "capture")
            cell.capture.addGestureRecognizer(captureTap)
            
            returnCell = cell
        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyFinalTableViewCell, forIndexPath: indexPath) as! ApplyFinalTableViewCell
            
            returnCell = cell
        }else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCellWithIdentifier(applyOfferTableViewCell, forIndexPath: indexPath) as! ApplyOfferTableViewCell
            
            returnCell = cell
        }

        return returnCell
    }
    
    func selectTime(sender: UIButton){
        let timeSelectTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TimeSelectTableViewController") as! TimeSelectTableViewController
        
        self.navigationController?.pushViewController(timeSelectTableViewController, animated: true)

    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0
        
        if indexPath.row == 0{
            rowHeight = 62
        }else if indexPath.row == 1{
            rowHeight = 59
        }else if indexPath.row == 2{
            rowHeight = 115
        }else if indexPath.row == 3{
            rowHeight = 136
        }else if indexPath.row == 4{
            rowHeight = 271
        }else if indexPath.row == 5{
            rowHeight = 305
        }else if indexPath.row == 6{
            rowHeight = 88
        }   
        
        return rowHeight
    }

}
