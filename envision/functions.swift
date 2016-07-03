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


func doRequest(url: String, parameters: [String: AnyObject]?, encoding:ParameterEncoding, praseMethod: (SwiftyJSON.JSON)-> Void){
    
    //let headersInput =  ["Content-Type":"application/json","Accept":"application/json"]
    
    Alamofire.request(.POST, url, parameters: parameters, encoding: encoding).responseJSON { response in
        if(response.data != nil && response.result.isSuccess){
            
            let json=SwiftyJSON.JSON(response.result.value!)
            
            NSLog("\(url) 成功, json = \(json)")
            
            praseMethod(json)
        }
        else{
            NSLog("\(url) 失败,response = \(response.response)")

        }
        
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String?) {
        if urlString == nil || urlString == ""{
            return
        }
        if let url = NSURL(string: urlString!) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if data != nil{
                    self.image = UIImage(data: data!)
                }
            }
        }
    }
}

func doRequestGetImage(imageURL: String){
    var image: UIImage?
    Alamofire.request(.GET, imageURL).response { (request, response,  data, error) in
        image = UIImage(data: data! as NSData,scale: 1)
        NSLog("\(imageURL), json = \(data)")
        if error != nil{
            NSLog("\(imageURL)失败,\(error)")
        }
    }
}

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
}

