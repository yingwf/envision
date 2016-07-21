//
//  FullResumeViewController.swift
//  envision
//
//  Created by  ywf on 16/7/19.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import WebKit

class FullResumeViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {

    
    var webSite: String = ""
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
        
        HUD.show(.RotatingImage(loadingImage))
        
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        //config.userContentController.addScriptMessageHandler(self, name: "webViewApp")
        self.webView = WKWebView(frame: self.view.frame, configuration: config)
        
        //self.webView.frame = self.view.bounds
        self.webView.UIDelegate = self
        self.webView.navigationDelegate = self
        
        
        
        let url = NSURL(string: self.webSite)
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        
        self.view.addSubview(self.webView)
        
        self.setBackButton()
        
    }
    
    //实现WKScriptMessageHandler委托
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {          //接受传过来的消息从而决定app调用的方法
        let dict = message.body as! Dictionary<String,String>
        
        let method:String = dict["method"]!
        let param1:String = dict["param1"]!
        if method=="hello"{
            //hello(param1)
        }
    }
    
    //    func webViewDidFinishLoad(webView: UIWebView){
    //        HUD.hide()
    //    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        HUD.hide()
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
