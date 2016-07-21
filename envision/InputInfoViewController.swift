//
//  InputInfoViewController.swift
//  envision
//
//  Created by  ywf on 16/6/12.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class InputInfoViewController: UIViewController {

    
    @IBOutlet weak var infoText: UITextField!
    var placeHolder = ""
    var originValue: String?
    var indexPath = NSIndexPath(forRow: 0, inSection: 0) //表示更新哪一行的信息
    var delegate: updateInfoDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoText.placeholder = placeHolder
        infoText.text = self.originValue
        infoText.becomeFirstResponder()
        

        self.setBackButton()
        
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }

    @IBAction func update(sender: AnyObject) {
        
        //验证格式
        if  !infoText.text!.isEmpty{
            if let title = self.navigationItem.title {
                switch(title){
                case "身份证号":
                    if !regularTest(infoText.text!, type: .idCard){
                        let alertView = UIAlertController(title: "提醒", message: "身份证号格式不正确", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                        alertView.addAction(okAction)
                        self.presentViewController(alertView, animated: false, completion: nil)
                        //HUD.flash(.LabeledError(title: "身份证号格式不正确", subtitle: ""), delay: 2.0)
                        return
                    }
                case "电子邮箱":
                    if !regularTest(infoText.text!, type: .email){
                        let alertView = UIAlertController(title: "提醒", message: "电子邮箱格式不正确", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                        alertView.addAction(okAction)
                        self.presentViewController(alertView, animated: false, completion: nil)
                        //HUD.flash(.LabeledError(title: "电子邮箱格式不正确", subtitle: ""), delay: 2.0)
                        return
                    }
                case "手机号":
                    if !regularTest(infoText.text!, type: .telephone){
                        let alertView = UIAlertController(title: "提醒", message: "手机号格式不正确", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                        alertView.addAction(okAction)
                        self.presentViewController(alertView, animated: false, completion: nil)
                        //HUD.flash(.LabeledError(title: "手机号格式不正确", subtitle: ""), delay: 2.0)
                        return
                    }
                default:
                    print("default")
                }
            }
            
        }


        
        
        self.delegate?.updateInfo(indexPath, info: infoText.text)
        self.navigationController?.popViewControllerAnimated(true)
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
