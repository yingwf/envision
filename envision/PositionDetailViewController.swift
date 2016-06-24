//
//  PositionDetailViewController.swift
//  envision
//
//  Created by  ywf on 16/6/1.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class PositionDetailViewController: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var shareBtn: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    var webSite: String = ""

    var shareView = YYShareView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: self.webSite)
        
        let request = NSURLRequest(URL: url!)
        
        self.webView.loadRequest(request)
        
        
        // Do any additional setup after loading the view.
        shareBtn.userInteractionEnabled = true
        shareBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "shareAction"))
        
        self.navigationItem.leftBarButtonItem = getBackButton(self)
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    func backToPrevious(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func shareAction(){
        shareView.vc = self
        shareView.show()
        
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
