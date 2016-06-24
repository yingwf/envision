//
//  YJImagePickerController.swift
//  envision
//
//  Created by  ywf on 16/6/18.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import AVFoundation


class YJImagePickerController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            
            self.sourceType = .Camera
            self.mediaTypes = [kUTTypeMovie as String]
            self.videoQuality = .Type640x480
            self.videoMaximumDuration = 15 //15s
        }else{
            print("摄像头不可使用")
        }
    }

    func saveVideo(info: [String : AnyObject]){
        let url = info[UIImagePickerControllerMediaURL] as! NSURL
        let tempFilePath = url.path
        print("tempFilePath:-----\(tempFilePath)")
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(tempFilePath!){
            UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath!, self, "video:didFinishSavingWithError:contextInfo:", nil)
        }
    }
    
    
    func video(video:NSString, didFinishSavingWithError error: NSError?,contextInfo:UnsafeMutablePointer<Void>){
        
        if error != nil{
            let alertView = UIAlertController(title: "提醒", message: error!.localizedDescription, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            
        }else{
            
            avCompressAndUpload(video as String)
        }
    }
    
    func avCompressAndUpload(sourceUrl: String){
        
        HUD.show(.LabeledRotatingImage(image: loadingImage,title:nil,subtitle:"视频上传中"))
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let filename = sourceUrl.componentsSeparatedByString("/").last!
        self.videoCompress(sourceUrl)
        //上传视频
        let username = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        let password = NSUserDefaults.standardUserDefaults().valueForKey("password") as? String
        let url = uploadFile + "?username=\(username!)&password=\(password!)&fileext=MOV&filetype=2"
        
        Alamofire.upload(.POST, url, headers:nil, multipartFormData: {
            multipartFormData in
            multipartFormData.appendBodyPart(data: NSData(contentsOfFile: sourceUrl)!, name: filename, mimeType: "video/quicktime")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON{ response in
                        HUD.hide()
                        
                        print(response)
                        if(response.data != nil && response.result.isSuccess){
                            let json=SwiftyJSON.JSON(response.result.value!)
                            print(json)
                            if json["success"].boolValue {
                                let alertView = UIAlertController(title: "提醒", message:"视频上传成功", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "确定", style: .Default) {(UIAlertAction) -> Void in
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                                alertView.addAction(okAction)
                                self.presentViewController(alertView, animated: true, completion: nil)
                            }else{
                                print("视频上传失败")
                                let alertView = UIAlertController(title: "提醒", message:"视频上传失败，请重新上传", preferredStyle: .Alert)
                                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                                alertView.addAction(okAction)
                                self.presentViewController(alertView, animated: true, completion: nil)
                            }
                        }else{
                            print("视频上传失败")
                            let alertView = UIAlertController(title: "提醒", message:"视频上传失败，请重新上传", preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                            alertView.addAction(okAction)
                            self.presentViewController(alertView, animated: true, completion: nil)
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    print("视频encoding失败")
                    let alertView = UIAlertController(title: "提醒", message:"视频录制失败，请重新录制", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                    alertView.addAction(okAction)
                    HUD.hide()
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
            }
        )
        
    }
    
    func videoCompress(sourceUrl: String){
        
        let avAsset = AVURLAsset(URL: NSURL(string: sourceUrl)!)
        
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetLowQuality)
        
        
        
        
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let filename = "output-\(formater.stringFromDate(NSDate())).mp4"
        let resultPath = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        exportSession?.outputURL = NSURL(string: resultPath)
        exportSession?.outputFileType = AVFileTypeMPEG4
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.exportAsynchronouslyWithCompletionHandler({
            switch (exportSession!.status) {
            case .Failed:
                print("视频压缩失败")
            case .Completed:
                print("视频压缩成功")
                
            default:
                print("default")
            }
        })
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
