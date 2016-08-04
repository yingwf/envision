//
//  LoginViewController.swift
//  envision
//
//  Created by  ywf on 16/6/3.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var pwdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.placeholder = "请输入账户名称"
        
        let width = self.view.frame.width
        let sepeView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
        sepeView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.22)
        nameView.addSubview(sepeView)
        
        let sepeButtonView = UIView(frame: CGRect(x: 0, y: 43.5, width: width, height: 0.5))
        sepeButtonView.backgroundColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 0.22)
        pwdView.addSubview(sepeButtonView)
        nameView.addSubview(sepeButtonView)

        
        let eyeView = UIImageView(frame: CGRect(x: 0, y: 19, width: 9, height: 6))
        eyeView.image = UIImage(named: "display-password")
        let tapGesture = UITapGestureRecognizer(target: self, action: "passwordEyeViewTap:")
        eyeView.userInteractionEnabled = true
        eyeView.addGestureRecognizer(tapGesture)
        pwdTextField.rightView = eyeView
        pwdTextField.rightViewMode = .WhileEditing
        
        let cancelView = UIImageView(frame: CGRect(x: 0, y: 16, width: 9, height: 9))
        cancelView.image = UIImage(named: "Backspace")
        let cancelViewTapGesture = UITapGestureRecognizer(target: self, action: "cancelViewTap:")
        cancelView.userInteractionEnabled = true
        cancelView.addGestureRecognizer(cancelViewTapGesture)
        nameTextField.rightView = cancelView
        nameTextField.rightViewMode = .WhileEditing
        
        nameTextField.delegate = self
        pwdTextField.delegate = self
        
        
        nameTextField.text = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        pwdTextField.text = NSUserDefaults.standardUserDefaults().valueForKey("password") as? String
        
        self.setBackButton()
    
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    
    }
    
    func cancelViewTap(sender: UITapGestureRecognizer) {
        nameTextField.text = ""
    }
    
    func passwordEyeViewTap(sender: UITapGestureRecognizer) {
        pwdTextField.secureTextEntry = !pwdTextField.secureTextEntry
    }
    
    
    @IBAction func registerAction(sender: AnyObject) {
        let registerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as! RegisterViewController
        
        self.navigationController?.pushViewController(registerViewController, animated: true)
        
        
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if nameTextField.text!.isEmpty {
            let alertView = UIAlertController(title: "提醒", message: "请输入账户名称", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        if pwdTextField.text!.isEmpty {
            let alertView = UIAlertController(title: "提醒", message: "请输入密码", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        HUD.show(.RotatingImage(loadingImage))
        let url = LOGIN
        var param = ["id":nameTextField.text!, "password":pwdTextField.text!, "phoneType":2 ] as [String : AnyObject]
        if deviceId != nil {
            param["deviceId"] = deviceId!
        }
        afRequest(url, parameters: param, encoding:.URL, praseMethod: praseLogin)
    }
    
    
    func praseLogin(json: SwiftyJSON.JSON){
        HUD.hide()

        if json["success"].boolValue {
            userinfo.getUserInfo(json)
            userinfo.jobId = json["jobId"].int
            userinfo.count = json["count"].int
            
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "login")//标识自动登录
            NSUserDefaults.standardUserDefaults().setObject(nameTextField.text!, forKey: "username")
            NSUserDefaults.standardUserDefaults().setObject(pwdTextField.text!, forKey: "password")

            
            if userinfo.name == "" || userinfo.name == nil{
                //未填写微简历时，需首先弹出微简历填写页面
                let editCVViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditCVViewController") as! EditCVViewController
                editCVViewController.needPopToRoot = true
                self.navigationController?.pushViewController(editCVViewController, animated: true)
                
            }else{
                myTableViewController?.updateUserInfo()
                
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            //首次使用登录时需检查badge
            if userinfo.count > 0 && BADGE == 0 {
                BADGE = userinfo.count!
                UIApplication.sharedApplication().applicationIconBadgeNumber = BADGE
                homeViewController?.tabBar.items?.last?.badgeValue = String(BADGE)
            }

        }else{
            var message = "登录失败，请重新登录"
            if json["message"].string != nil{
                message = json["message"].string!
            }
            let alertView = UIAlertController(title: "提醒", message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        
    }


    @IBAction func findPassword(sender: AnyObject) {
        
        let findPasswordViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FindPasswordViewController") as! FindPasswordViewController
        
        self.navigationController?.pushViewController(findPasswordViewController, animated: true)
        
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
