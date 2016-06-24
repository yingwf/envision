//
//  YYShareView.swift
//  envision
//
//  Created by  ywf on 16/6/2.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class YYShareView: UIView {
    
    var vc: UIViewController?
    
    var backgroundView: UIView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    
    
    func show(){
        let shareView = NSBundle.mainBundle().loadNibNamed("ShareView", owner: nil, options: nil).first as? ShareView
        
        if shareView != nil {
            
            let tapWeChatFriend = UITapGestureRecognizer(target: self, action: "didClickOnWeChatFriend")
            let tapFriendCircle = UITapGestureRecognizer(target: self, action: "didClickOnFriendCircle")
            
            shareView!.weChatFriend.addGestureRecognizer(tapWeChatFriend)
            shareView!.friendCircle.addGestureRecognizer(tapFriendCircle)
            
            let height = UIScreen.mainScreen().bounds.height
            let width = UIScreen.mainScreen().bounds.width
            let viewHeight = shareView!.bounds.height
            
            backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
            backgroundView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            
            let tapGR = UITapGestureRecognizer(target: self, action: "tapCancel")
            self.backgroundView!.userInteractionEnabled = true
            self.backgroundView!.addGestureRecognizer(tapGR)
            //shareViewe!.addGestureRecognizer(tapGR)
            
            shareView!.frame = CGRect(x: 0, y: height, width: width, height: viewHeight)
            
            shareView!.cancelBtn.addTarget(self, action: "remove:", forControlEvents: UIControlEvents.TouchUpInside)
            //shareView?.addGestureRecognizer(tapGR)
            
            backgroundView!.addSubview(shareView!)
            
            UIApplication.sharedApplication().keyWindow?.addSubview(backgroundView!)
            
            UIView.animateWithDuration(0.15, animations: {
                
                shareView!.frame = CGRect(x: 0, y: height - viewHeight, width: width, height: viewHeight)
                self.backgroundView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
                
            })
        }
    }
    
    func tapCancel(){
        self.backgroundView!.removeFromSuperview()
        self.backgroundView = nil
    }
    
    func remove(sender:UIButton!){
        self.backgroundView!.removeFromSuperview()
        self.backgroundView = nil
        
    }
    
//    func findViewController(sourceView: UIView) -> UIViewController{
//        var vc: UIViewController?
//        var target = sourceView as? UIResponder
//        while((target) != nil){
//            let responder = target!.nextResponder()
//            if target!.isKindOfClass(UIViewController){
//                let vc = target
//                break
//            }
//        }
//        return vc!
//    }
    
    func didClickOnWeChatFriend(){
        
        if !WXApi.isWXAppInstalled() {
            let alertView = UIAlertController(title: "提醒", message: "没有安装微信，不能转发分享", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){(UIAlertAction) -> Void in
                return
            }
            alertView.addAction(okAction)
            self.vc?.presentViewController(alertView, animated: true, completion: nil)
        }
        
        
        let message = WXMediaMessage()
        message.title = "标题"
        message.description = "描述"
        message.setThumbImage(UIImage(named: "logo"))

        
        let webpageObject = WXWebpageObject()
        webpageObject.webpageUrl = getjobInfoUrl + "?id=198"
        message.mediaObject = webpageObject
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 0 //WXSceneSession
        
        WXApi.sendReq(req)
        
    }
    
    func didClickOnFriendCircle(){
        
        if !WXApi.isWXAppInstalled() {
            let alertView = UIAlertController(title: "提醒", message: "没有安装微信，不能转发分享", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default){(UIAlertAction) -> Void in
                return
            }
            alertView.addAction(okAction)
            self.vc?.presentViewController(alertView, animated: true, completion: nil)
        }
        
        
        //创建分享内容对象
        let message = WXMediaMessage()
        message.title = "标题"
        message.description = "描述"
        message.setThumbImage(UIImage(named: "logo"))
        
        //创建多媒体对象
        let webpageObject = WXWebpageObject()
        webpageObject.webpageUrl = getjobInfoUrl + "?id=198"
        message.mediaObject = webpageObject
        
        //完成发送对象实例
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        req.scene = 1 //WXSceneTimeline
        
        //发送分享信息
        WXApi.sendReq(req)
        
    }


}
