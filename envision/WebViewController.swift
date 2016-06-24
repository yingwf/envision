//
//  WebViewController.swift
//  envision
//
//  Created by  ywf on 16/5/30.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var webSite: String = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hidesBottomBarWhenPushed = true
        
        let url = NSURL(string: self.webSite)
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        self.navigationItem.leftBarButtonItem = getBackButton(self)
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
    }
    
    func backToPrevious(){
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
