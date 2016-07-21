//
//  AppDelegate.swift
//  envision
//
//  Created by  ywf on 16/5/26.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON

let kGtAppId:String = "kh6wXq5XFi91TPixoXhpQ8"
let kGtAppKey:String = "JJVjtoWbUfAL6ENTYOJOs3"
let kGtAppSecret:String = "IeqXsCaMiTAiqncMpyo9q8"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,GeTuiSdkDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        WXApi.registerApp("wx658cf26421d80331")
        
        // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
        GeTuiSdk.startSdkWithAppId(kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self)
        
        // 注册Apns
        self.registerUserNotification(application)
        
        return true
    }
    
    
    // MARK: - 用户通知(推送) _自定义方法
    
    /** 注册用户通知(推送) */
    func registerUserNotification(application: UIApplication) {
        let result = UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch)
        if (result != NSComparisonResult.OrderedAscending) {
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
            let userSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(userSettings)
        } else {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes([.Alert, .Sound, .Badge])
        }
    }
    
    
    // MARK: - 远程通知(推送)回调
    
    /** 远程通知注册成功委托 */
    func application(application: UIApplication, var didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // [3]:向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceToken(token)
        
        //自动登录
        deviceId = token
        autoLogin()
        
        NSLog("\n>>>[DeviceToken Success]:%@\n\n",token)
    }
    
    /** 远程通知注册失败委托 */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSLog("\n>>>[DeviceToken Error]:%@\n\n",error.description);
    }
    
    // MARK: - APP运行中接收到通知(推送)处理
    
    /** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        application.applicationIconBadgeNumber = 0;        // 标签
        
        myApplyTableViewController?.updateInfo()
        print("update interview info")
        
        //        if userInfo["aps"] != nil && userInfo["aps"]!["alert"] != nil && userInfo["aps"]!["alert"]!!["title"] != nil && (userInfo["aps"]!["alert"]!!["title"]! as! String) == "当前面试信息" {
        
        NSLog("\n>>>[Receive RemoteNotification]:%@\n\n",userInfo);
    }
    
    // MARK: - GeTuiSdkDelegate
    
    /** SDK启动成功返回cid */
    func GeTuiSdkDidRegisterClient(clientId: String!) {
        // [4-EXT-1]: 个推SDK已注册，返回clientId
        NSLog("\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    }
    
    /** SDK遇到错误回调 */
    func GeTuiSdkDidOccurError(error: NSError!) {
        // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
        NSLog("\n>>>[GeTuiSdk error]:%@\n\n", error.localizedDescription);
    }
    
    /** SDK收到sendMessage消息回调 */
    func GeTuiSdkDidSendMessage(messageId: String!, result: Int32) {
        // [4-EXT]:发送上行消息结果反馈
        let msg:String = "sendmessage=\(messageId),result=\(result)";
        NSLog("\n>>>[GeTuiSdk DidSendMessage]:%@\n\n",msg);
    }
    
    func GeTuiSdkDidReceivePayloadData(payloadData: NSData!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        
        var payloadMsg = "";
        if((payloadData) != nil) {
            payloadMsg = String.init(data: payloadData, encoding: NSUTF8StringEncoding)!;
        }
        
        let msg:String = "Receive Payload: \(payloadMsg), taskId:\(taskId), messageId:\(msgId)";
        
        NSLog("\n>>>[GeTuiSdk DidReceivePayload]:%@\n\n",msg);
    }



    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool{
        
        WXApi.handleOpenURL(url, delegate:self)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool{
        
         WXApi.handleOpenURL(url, delegate:self)
        return true
    }
    
    func onResp(resp: BaseResp){
        
//        if resp.isKindOfClass(SendMessageToWXResp){
//            let alertView = UIAlertController(title: "发送媒体消息结果", message: resp.errStr, preferredStyle: .Alert)
//            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
//            alertView.addAction(okAction)
//        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func autoLogin(){
        let login = NSUserDefaults.standardUserDefaults().valueForKey("login") as? Bool
        
        if (login != nil) && login! {
            let username = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
            let password = NSUserDefaults.standardUserDefaults().valueForKey("password") as? String
            
            if username == nil || password == nil{
                return
            }
            
            let url = LOGIN
            let param = ["id": username! , "password":password! , "deviceId":deviceId!, "phoneType":2 ] as [String : AnyObject]
            doRequest(url, parameters: param, encoding:.URL, praseMethod: praseLogin)
        }
    }
    
    
    func praseLogin(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            userinfo.getUserInfo(json)
            myTableViewController?.updateUserInfo()
        }
    }
    

}

