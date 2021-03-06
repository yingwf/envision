//
//  EditCVViewController.swift
//  envision
//
//  Created by  ywf on 16/6/7.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


protocol updateInfoDelegate{
    //更新简历信息
    func updateInfo(indexPath: NSIndexPath, info: String?)
}

class EditCVViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, updateInfoDelegate {

    let cvHintCell = "CVhintTableViewCell"
    let cvEditCell = "CVeditTableViewCell"
    let sectionTitle = ["真实姓名","身份证号","电子邮箱","手机号","性别","最高学历","毕业学校","专业名称","毕业年份"]
    let genders = ["男","女"]
    let degrees = ["大专","本科","硕士","博士"]
    var valueArray = ["","","","","","","","",""]
    var needPopToRoot = false //注册，登录后完善简历时，保存后需回退到“偏执狂中心”页面

    @IBOutlet weak var tableView: UITableView!
    
    var isModify = false //标示是修改还是新建，修改时不允许调整姓名等，新建是均可允许
    
    var delegate: RefreshUserInfoDelegate?
    
    var pickerView: UIPickerView?
    
    var datePicker: UIDatePicker?
    var graduateYear = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        
        self.tableView.registerNib(UINib(nibName: "CVhintTableViewCell", bundle: nil), forCellReuseIdentifier: cvHintCell)
        
        self.tableView.registerNib(UINib(nibName: "CVeditTableViewCell", bundle: nil), forCellReuseIdentifier: cvEditCell)
        
        //初始化毕业年份,2010年 - 2035年
        for index in 0...25 {
            self.graduateYear.append(String(index + 2010))
        }
        
        self.setBackButton()
            
    }
    
    
    func updateInfo(indexPath: NSIndexPath, info: String?){
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CVeditTableViewCell
        cell.value.text = info
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 5
        }
        return 5
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cvHintCell, forIndexPath: indexPath) as! CVhintTableViewCell
            
            if isModify {
                cell.hint.text = "姓名，邮箱，身份证，手机号不可编辑。"
            }else {
                cell.hint.text = "姓名，邮箱，身份证，手机号，填写后无法修改，请确保准确。"
            }
            
            cell.selectionStyle = .None
            returnCell = cell
        }else if (indexPath.section == 0) && (indexPath.row > 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cvEditCell, forIndexPath: indexPath) as! CVeditTableViewCell
            cell.title.text = self.sectionTitle[indexPath.row - 1]
            cell.value.placeholder = "填写"
            
            //初始化
            switch indexPath.row{
            case 1:
                cell.value.text = userinfo.name
            case 2:
                cell.value.text = userinfo.identity
            case 3:
                cell.value.text = userinfo.email
            case 4:
                cell.value.text = userinfo.mobile
            default:
                print("default")
            }
            
            if isModify {
                cell.selectionStyle = .None
            }
            returnCell = cell
        }else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier(cvEditCell, forIndexPath: indexPath) as! CVeditTableViewCell
            cell.title.text = self.sectionTitle[indexPath.row + 4]
            
            //初始化
            switch indexPath.row{
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
        if indexPath.section == 0{
            if indexPath.row == 0{
                return
            }
            if isModify {
                //修改简历时，姓名等不可更改
                return
            }
            let inputInfoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InputInfoViewController") as! InputInfoViewController
            inputInfoViewController.navigationItem.title = self.sectionTitle[indexPath.row - 1]
            inputInfoViewController.placeHolder = "请输入" + self.sectionTitle[indexPath.row - 1]
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! CVeditTableViewCell
            inputInfoViewController.originValue = cell.value.text
            inputInfoViewController.indexPath = indexPath
            inputInfoViewController.delegate = self
            self.navigationController?.pushViewController(inputInfoViewController, animated: true)

            
        }else if indexPath.section == 1{
            if indexPath.row == 0{
                //性别
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! CVeditTableViewCell
                selectValue(cell.value, value: genders)
                
            }else if indexPath.row == 1{
                //最高学历
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! CVeditTableViewCell
                selectValue(cell.value, value: degrees)
            }else if indexPath.row == 2{
                //毕业学校
                let searchVCViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchVCViewController") as! SearchVCViewController
                searchVCViewController.isSearchSchool = true
                searchVCViewController.indexPath = indexPath
                searchVCViewController.delegate = self
                self.presentViewController(searchVCViewController, animated: true, completion: nil)
                
            }else if indexPath.row == 3{
                //专业名称
                let searchVCViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchVCViewController") as! SearchVCViewController
                searchVCViewController.isSearchSchool = false
                searchVCViewController.indexPath = indexPath
                searchVCViewController.delegate = self
                self.presentViewController(searchVCViewController, animated: true, completion: nil)
                
            }else if indexPath.row == 4{
                //毕业年份
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! CVeditTableViewCell
                
                let sheetView = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                
                let width = UIScreen.mainScreen().bounds.width
                pickerView = UIPickerView(frame: CGRectMake(0, 0, width - 20, 200))
                pickerView!.delegate = self
                pickerView!.dataSource = self
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy"
                var thisYear = Int(dateFormatter.stringFromDate(NSDate()))
                if let text = cell.value.text{
                    let currentYear = (text as NSString).intValue
                    if currentYear >= 2010 && currentYear <= 2035{
                        thisYear = Int(currentYear)
                    }
                }
                
                pickerView?.selectRow(thisYear! - 2010, inComponent: 0, animated: false)
                
                
                let okAction = UIAlertAction(title: "确定", style:UIAlertActionStyle.Default){ (UIAlertAction) -> Void in
                    let row = self.pickerView?.selectedRowInComponent(0)
                    guard (row != nil) else{
                        sheetView.dismissViewControllerAnimated(true, completion: nil)
                        return
                    }
                    cell.value.text = self.graduateYear[row!]
                    sheetView.dismissViewControllerAnimated(true, completion: nil)
                }
                
                //let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
                
                sheetView.addAction(okAction)
                sheetView.view.addSubview(pickerView!)
                
                
                self.presentViewController(sheetView, animated: true, completion: nil)
                
                
            }
            
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.graduateYear[row]
    }
    
    func selectValue(label:UITextField, value:[String]) {
        let sheetView = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
        sheetView.addAction(cancelAction)

        for index in 0...value.count - 1 {
            let otherAction = UIAlertAction(title: value[index], style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                label.text = value[index]
                sheetView.dismissViewControllerAnimated(true, completion: nil)
            }
            sheetView.addAction(otherAction)

        }

        self.presentViewController(sheetView, animated: true, completion: nil)
    }


    //保存简历
    @IBAction func saveCV(sender: AnyObject) {

        for index in 1...4{
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! CVeditTableViewCell
            if cell.value.text == "" { // && !isModify
                let alertView = UIAlertController(title: "提醒", message: "请输入\(self.sectionTitle[index - 1])", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                return
            }else{
                valueArray[index - 1] = cell.value.text!
            }
        }

        for index in 0...4{
            let indexPath = NSIndexPath(forRow: index, inSection: 1)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! CVeditTableViewCell
            if  cell.value.text == "" {
                let alertView = UIAlertController(title: "提醒", message: "请选择\(self.sectionTitle[index + 4])", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                return
            }else{
                valueArray[index + 4] = cell.value.text!
            }
        }
        
        let mobile = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
        
        let url = applicantUpdate
        var param = ["mobile":mobile, "name":valueArray[0], "IDcard":valueArray[1], "email":valueArray[2], "gendar":valueArray[4], "educationLevel":valueArray[5], "lastschool":valueArray[6], "lastdisciplinekind":valueArray[7], "graduationdate":valueArray[8]] as [String : AnyObject]
//        if isModify{
//            param = ["gendar":valueArray[3], "educationLevel":valueArray[4], "lastschool":valueArray[5], "lastdisciplinekind":valueArray[6], "graduationdate":valueArray[7]]
//        }
        HUD.show(.RotatingImage(loadingImage))
        afRequest(url, parameters: param, encoding: .URL, praseMethod: praseSaveResult)

    }
    
    func praseSaveResult(json: SwiftyJSON.JSON){
        HUD.hide()
        if json["success"].boolValue {
            userinfo.getUserInfo(json)
            
            let alertView = UIAlertController(title: "提醒", message: "已保存简历", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){ (UIAlertAction) -> Void in

                if self.needPopToRoot {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }else{
                    self.delegate?.refreshUserInfo()
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
                myTableViewController?.updateUserInfo()//更新用户信息
            }
            
//            //成功后保存到全局变量userinfo
//            userinfo.name = valueArray[0]
//            userinfo.identity = valueArray[1]
//            userinfo.email = valueArray[2]
//            userinfo.mobile = valueArray[3]
//            userinfo.gender = valueArray[4]
//            userinfo.educationLevel = valueArray[5]
//            userinfo.lastschool = valueArray[6]
//            userinfo.lastDisciplineKind = valueArray[7]
//            userinfo.graduationDate = valueArray[8]
            alertView.addAction(okAction)
            
            self.presentViewController(alertView, animated: false, completion: nil)
            
        }else{
            var message = "简历保存失败，请重新保存"
            if json["message"].string != nil{
                message = json["message"].string!
            }
            let alertView = UIAlertController(title: "提醒", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: false, completion: nil)

        }
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
