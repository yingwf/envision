//
//  InterviewMgrViewController.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class InterviewMgrViewController: UIViewController {

    @IBOutlet weak var currentApplicant: UIButton!
    @IBOutlet weak var nextApplicant: UIButton!
    @IBOutlet weak var endInterview: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentApplicant.layer.cornerRadius = 5
        currentApplicant.layer.masksToBounds = true
        
        currentApplicant.layer.borderWidth = 0.5
        currentApplicant.layer.borderColor = SYSTEMCOLOR.CGColor
        
        nextApplicant.layer.cornerRadius = 5
        nextApplicant.layer.masksToBounds = true
        endInterview.layer.cornerRadius = 5
        endInterview.layer.masksToBounds = true
        
        let sepView = UIView(frame: CGRect(x: 16, y: 115, width: self.view.frame.width - 32, height: 0.5))
        sepView.backgroundColor = BACKGROUNDCOLOR
        self.view.addSubview(sepView)
    }

    @IBAction func endInterview(sender: AnyObject) {
        let endInterviewTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EndInterviewTableViewController") as! EndInterviewTableViewController
        self.navigationController?.pushViewController(endInterviewTableViewController, animated: true)
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
