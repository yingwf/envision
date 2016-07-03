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

        //self.navigationItem.leftBarButtonItem = getBackButton(self)
        self.setBackButton()

        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
//    func backToPrevious(){
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    

    @IBAction func update(sender: AnyObject) {
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
