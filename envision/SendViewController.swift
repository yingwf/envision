//
//  SendViewController.swift
//  envision
//
//  Created by  ywf on 16/7/1.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

protocol RefreshUserInfoDelegate {
    
    func refreshUserInfo()
    
}

class SendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,RefreshUserInfoDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    var imagePickerController: YJImagePickerController?

    
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
        
        
        //HUD.show(.RotatingImage(loadingImage))
        
        //self.navigationItem.leftBarButtonItem = getBackButton(self)
        self.setBackButton()

        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
//    func backToPrevious(){
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    
    @IBAction func applyJob(sender: AnyObject) {
        
//        let introViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
//        introViewController.webSite = applyjob
//        introViewController.navigationItem.title = "职位申请"
//        self.navigationController?.pushViewController(introViewController, animated: true)
        
        
    }
    
    func refreshUserInfo(){
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    func editCV(sender: UITapGestureRecognizer){
        
        let editCVViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditCVViewController") as! EditCVViewController
        editCVViewController.delegate = self
        
        self.navigationController?.pushViewController(editCVViewController, animated: true)
    }
    
    func recordVideo(){
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
