//
//  functions.swift
//  SouTaiji
//
//  Created by  ywf on 16/5/3.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

func getDateFromString(datetime: String?)->String?{
    if datetime == nil{
        return nil
    }
    let datetimeArray = datetime!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: " "))
    return datetimeArray[0]
}

func getTimeFromString(datetime: String?)->String?{
    if datetime == nil{
        return nil
    }
    let datetimeArray = datetime!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: " "))
    guard datetimeArray.count >= 1 else{
        return nil
    }
    let timeArray = datetimeArray[1].componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: ":"))
    guard timeArray.count >= 1 else{
        return nil
    }
    return timeArray[0] + ":" + timeArray[1]
}

func getMonthAndDayFromString(datetime: String?)->String?{
    if datetime == nil{
        return nil
    }
    let datetimeArray = datetime!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "-"))
    var returnDatetime: String?
    
    if datetimeArray.count >= 3{
        returnDatetime = datetimeArray[1] + "-" + datetimeArray[2]
    }
    return returnDatetime
}

func afRequest(url: String, parameters: [String: AnyObject]?, encoding:ParameterEncoding, praseMethod: (SwiftyJSON.JSON)-> Void){
    
    //let headersInput =  ["Content-Type":"application/json","Accept":"application/json"]
    print(parameters)
    
    Alamofire.request(.POST, url, parameters: parameters, encoding: encoding).responseJSON { response in
        if(response.data != nil && response.result.isSuccess){

            let json = SwiftyJSON.JSON(response.result.value!)
            
            NSLog("\(url) 成功, json = \(json)")
            
            praseMethod(json)
        }
        else{
            NSLog("\(url) 失败,response = \(response.response)")
            let json = SwiftyJSON.JSON(response.result.error!)
            praseMethod(json)
        }
        
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String?) {
        if urlString == nil || urlString == ""{
            return
        }
        
        //本地查询文件
        if let imageData = getFile(urlString) {
            self.image = UIImage(data: imageData)
            return
        }
        
        if let url = NSURL(string: urlString!) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if data != nil{
                    self.image = UIImage(data: data!)
                    //本地保存文件
                    saveFile(data!, urlString: urlString)
                }
            }
        }
    }
}

func getFile(filePath: String?) -> NSData? {
    //根据文件名，获取data
    guard filePath != nil else {
        return nil
    }
    let filename = filePath!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "/")).last
    guard filename != nil else {
        return nil
    }
    
    let fileManager = NSFileManager.defaultManager()
    
    let imageDir = NSHomeDirectory() + "/Documents/images"
    
    if fileManager.fileExistsAtPath(imageDir + "/\(filename!)") {
        return NSData(contentsOfFile: imageDir + "/\(filename!)")
    }else{
        return nil
    }
}

func saveFile(data: NSData, urlString: String?){
    //本地保存文件
    guard let filePath = urlString else {
        return
    }
    let filePath1 = filePath.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "?")).first
    guard filePath1 != nil else {
        return
    }
    
    let filename = filePath1!.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "/")).last
    guard filename != nil else {
        return
    }
    
    let fileManager = NSFileManager.defaultManager()
    
    let imageDir = NSHomeDirectory() + "/Documents/images"

    let imageUrl = NSURL(fileURLWithPath: imageDir, isDirectory: true)
    
    do {
        try fileManager.createDirectoryAtURL(imageUrl, withIntermediateDirectories: true, attributes: nil)
    } catch {
        return
    }
    data.writeToFile(imageDir + "/\(filename!)", atomically: true)
}


//func afRequestGetImage(imageURL: String){
//    var image: UIImage?
//    Alamofire.request(.GET, imageURL).response { (request, response,  data, error) in
//        image = UIImage(data: data! as NSData,scale: 1)
//        NSLog("\(imageURL), json = \(data)")
//        if error != nil{
//            NSLog("\(imageURL)失败,\(error)")
//        }
//    }
//}

func getBackButton(vc: UIViewController) -> UIBarButtonItem{
    
    let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
    let backImage = UIImageView(frame: CGRect(x: -8, y: 5, width: 14, height: 22))
    backImage.image = UIImage(named: "back")
    backButton.addSubview(backImage)
    backButton.addTarget(vc, action: "backToPrevious", forControlEvents: .TouchUpInside)
    let backItem = UIBarButtonItem(customView: backButton)
    backItem.tintColor = UIColor.whiteColor()
    return backItem
}

//extension SYQRCodeViewController {
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        self.setBackButton()
//    }
//}

extension UIViewController:UIGestureRecognizerDelegate {
    func backToPrevious(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func setBackButton(){
        //        let leftBarBtn = UIBarButtonItem(title: "", style: .Plain, target: self,
        //            action: "backToPrevious")
        //        leftBarBtn.image = UIImage(named: "back")
        //        leftBarBtn.tintColor = UIColor.whiteColor()
        //        self.navigationItem.leftBarButtonItem = leftBarBtn
        
        //        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        //        let backImage = UIImageView(frame: CGRect(x: -8, y: 5, width: 14, height: 22))
        //        backImage.image = UIImage(named: "back")
        //        backButton.addSubview(backImage)
        //        backButton.addTarget(self, action: "backToPrevious", forControlEvents: .TouchUpInside)
        //        let backItem = UIBarButtonItem(customView: backButton)
        //        backItem.tintColor = UIColor.whiteColor()
        //self.navigationItem.leftBarButtonItem = getBackButton(self)
        
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        let backImage = UIImageView(frame: CGRect(x: -8, y: 5, width: 14, height: 22))
        backImage.image = UIImage(named: "back")
        backButton.addSubview(backImage)
        backButton.addTarget(self, action: "backToPrevious", forControlEvents: .TouchUpInside)
        let backItem = UIBarButtonItem(customView: backButton)
        backItem.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self

    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

