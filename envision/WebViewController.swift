//
//  WebViewController.swift
//  envision
//
//  Created by  ywf on 16/5/30.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
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

        //self.navigationItem.leftBarButtonItem = getBackButton(self)
        self.setBackButton()

        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
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
    
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void){
        
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: { (ac) -> Void in
            completionHandler()
        }))
        
        self.presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void){

        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:
            { (ac) -> Void in
                completionHandler(true)//按确定的时候传true
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:
            { (ac) -> Void in
                completionHandler(false)//取消传false
        }))
        
        self.presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void){
        let alertView = UIAlertController(title: "告警", message: prompt, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alertView.addAction(okAction)
        self.presentViewController(alertView, animated: false, completion: nil)
        
    }
    
    
    
//    func backToPrevious(){
//        self.navigationController?.popViewControllerAnimated(true)
//    }

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
