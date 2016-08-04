//
//  RegisterViewController.swift
//  envision
//
//  Created by  ywf on 16/6/3.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var verificationCodeField: UITextField!
    
    @IBOutlet weak var identityField: UITextField!
    @IBOutlet weak var identityView: UIView!
    
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var timer: NSTimer?
    var leftTime = 60 //60秒
    var receiveVerificaitonCodeTap: UITapGestureRecognizer?
    
    @IBOutlet weak var receiveLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = "手机："
        userNameField.placeholder = "请输入11位手机号码"
        verificationCodeField.placeholder = "输入验证码"
        
        receiveLabel.userInteractionEnabled = true
        receiveVerificaitonCodeTap = UITapGestureRecognizer(target: self, action: "receiveVerificationCode")
        receiveLabel.addGestureRecognizer(receiveVerificaitonCodeTap!)
        
        let width = self.view.frame.width
        
        for index in 0...4{
            let sepeView = UIView()
            sepeView.frame =  CGRect(x: 0, y: 84 + CGFloat(CGFloat(index) * 44.5), width: width, height: 0.5)
            sepeView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.22)
            self.view.addSubview(sepeView)
        }
        
        let selectTap = UITapGestureRecognizer(target: self, action: "selectIdentity")
        self.identityView.userInteractionEnabled = true
        self.identityView.addGestureRecognizer(selectTap)
            
        
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.setBackButton()

    }

    
    func textFieldDidBeginEditing(textField: UITextField){
        print("beginediting")
    }
    
    func receiveVerificationCode() {
        if userNameField.text!.isEmpty {
            let alertView = UIAlertController(title: "提醒", message: "请输入手机号码", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        
        let url = getCode
        let param = ["mobile":userNameField.text!] as [String : AnyObject]
        afRequest(url, parameters: param, encoding: .URL, praseMethod: praseVerificationCode)
        
        self.receiveLabel.removeGestureRecognizer(receiveVerificaitonCodeTap!)
        self.receiveLabel.text = "已接收：60s"
        self.addTimer()
    }
    
    func praseVerificationCode(json: SwiftyJSON.JSON){
        
    }
    
    
    //开启定时器
    func addTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "nextSecond", userInfo: nil, repeats: true)
    }
    //关闭定时器
    func removeTimer(){
        self.timer?.invalidate()
        self.receiveLabel.addGestureRecognizer(receiveVerificaitonCodeTap!)
    }
    
    func nextSecond(){
        leftTime--
        if leftTime > 0 {
            self.receiveLabel.text = "已接收：\(leftTime)s"
        }else{
            self.receiveLabel.text = "再次接收"
            self.removeTimer()
            leftTime = 60
        }
    }
    
    func selectIdentity() {
        let sheetView = UIAlertController(title: "选择身份", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style:UIAlertActionStyle.Cancel, handler: nil)
        let teacherAction = UIAlertAction(title: "老师", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.identityField.text = "老师"
            sheetView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let studentAction = UIAlertAction(title: "学生", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.identityField.text = "学生"
            sheetView.dismissViewControllerAnimated(true, completion: nil)
        }
        
        sheetView.addAction(cancelAction)
        sheetView.addAction(teacherAction)
        sheetView.addAction(studentAction)
        
        self.presentViewController(sheetView, animated: true, completion: nil)
    }
    
    
    @IBAction func register(sender: AnyObject) {

        if userNameField.text!.isEmpty {
            let alertView = UIAlertController(title: "提醒", message: "请输入手机号码", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        if passwordField.text!.isEmpty {
            let alertView = UIAlertController(title: "提醒", message: "请输入密码", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        if verificationCodeField.text!.isEmpty {
            let alertView = UIAlertController(title: "提醒", message: "请输入验证码", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        if identityField.text!.isEmpty {
            let alertView = UIAlertController(title: "提醒", message: "请选择身份", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        
        var userType = 1
        if identityField.text! == "老师"{
            userType  = 2
        }
        
        let url = REGISTER
        let param = ["mobile": userNameField.text! , "password":passwordField.text!, "code":verificationCodeField.text!, "type":String(userType)] as [String : AnyObject]
        afRequest(url, parameters: param, encoding:.URL, praseMethod: praseRegister)
        
    }
    
    func praseRegister(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            userinfo.getUserInfo(json)
            
            //注册成功
            let alertView = UIAlertController(title: "提醒", message:"注册成功，请填写简历", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default) {(UIAlertAction) -> Void in
                NSUserDefaults.standardUserDefaults().setObject(true, forKey: "login")//标识自动登录
                NSUserDefaults.standardUserDefaults().setObject(self.userNameField.text!, forKey: "username")
                NSUserDefaults.standardUserDefaults().setObject(self.passwordField.text!, forKey: "password")
                
                let editCVViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditCVViewController") as! EditCVViewController
                editCVViewController.needPopToRoot = true
                
                self.navigationController?.pushViewController(editCVViewController, animated: true)
                
                myTableViewController?.autoLogin()
                
            }
            alertView.addAction(okAction)
            
            self.presentViewController(alertView, animated: true, completion: nil)
            
            
        }else{
            var message = "注册失败"
            if json["message"].string != nil{
                message = json["message"].string!
            }
            let alertView = UIAlertController(title: "提醒", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
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
