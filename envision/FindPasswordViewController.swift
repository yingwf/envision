//
//  FindPasswordViewController.swift
//  envision
//
//  Created by  ywf on 16/6/15.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class FindPasswordViewController: UIViewController {

    var timer: NSTimer?
    var leftTime = 60 //60秒
    var receiveVerificaitonCodeTap: UITapGestureRecognizer?
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var receiveLabel: UILabel!
    
    @IBOutlet weak var verificationCodeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receiveLabel.userInteractionEnabled = true
        receiveVerificaitonCodeTap = UITapGestureRecognizer(target: self, action: #selector(receiveVerificationCode))
        receiveLabel.addGestureRecognizer(receiveVerificaitonCodeTap!)
        
        let width = self.view.frame.width
        
        for index in 0...3{
            let sepeView = UIView()
            sepeView.frame =  CGRect(x: 0, y: 84 + CGFloat(CGFloat(index) * 44.5), width: width, height: 0.5)
            sepeView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.22)
            self.view.addSubview(sepeView)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.setBackButton()
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        print("beginediting")
    }
    
    func receiveVerificationCode() {
        if userNameField.text!.isEmpty {
            let alertView = UIAlertController(title: "提醒", message: "请输入登录账户", preferredStyle: .Alert)
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
    
    @IBAction func resetAction(sender: AnyObject) {
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
        
        let url = findPassword
        let param = ["mobile": userNameField.text! , "password":passwordField.text!, "code":verificationCodeField.text!] as [String : AnyObject]
        afRequest(url, parameters: param, encoding:.URL, praseMethod: praseFindPassword)
        
    }
    
    func praseFindPassword(json: SwiftyJSON.JSON){
        if json["success"].boolValue {

            let alertView = UIAlertController(title: "提醒", message:"重置密码成功", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default) {(UIAlertAction) -> Void in
                
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertView.addAction(okAction)
            
            self.presentViewController(alertView, animated: true, completion: nil)
            
            
        }else{
            let alertView = UIAlertController(title: "提醒", message: json["message"].string, preferredStyle: .Alert)
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
