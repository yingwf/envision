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
    
    var url: String?
    var delegate2: UpdateVideoUrlDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            
            self.sourceType = .Camera
            self.mediaTypes = [kUTTypeMovie as String]
            self.videoQuality = .Type640x480
            self.videoMaximumDuration = 15 //15s
        }else{
            print("摄像头不可使用")
            return
        }
    }

    func saveVideo(info: [String : AnyObject]){
        let url = info[UIImagePickerControllerMediaURL] as! NSURL
        let tempFilePath = url.path
        print("tempFilePath:-----\(tempFilePath)")
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(tempFilePath!){
            UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath!, self, "video:didFinishSavingWithError:contextInfo:", nil)
        }
//        let fileManager = NSFileManager.defaultManager()
//        let formater = NSDateFormatter()
//        formater.dateFormat = "yyyyMMddHHmmss"
//        let filename = "video\(formater.stringFromDate(NSDate())).MOV"
//        let resultPath = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
//        do {
//            try fileManager.copyItemAtPath(tempFilePath!, toPath: resultPath)
//        }catch let error as NSError{
//            print(error.localizedDescription)
//        }
//        print("resultPath:-----\(resultPath)")
//        avCompressAndUpload(resultPath as String)
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
        
        //压缩视频
        //self.videoCompress(sourceUrl)
        //self.convertVideoWithMediumQuality(NSURL(string: sourceUrl)!)
        
        //self.convertVideoWithMediumQuality(NSURL(fileURLWithPath: sourceUrl, isDirectory: false))

        
        //上传视频
        let url = uploadFile
        Alamofire.upload(.POST, url, multipartFormData: {
            multipartFormData in
            let data = NSData(contentsOfFile: sourceUrl)!
            multipartFormData.appendBodyPart(data: data, name: "file", fileName:filename, mimeType: "video/quicktime")
            
            let param = ["name" : userinfo.name!, "email" : userinfo.email!, "mobile": userinfo.mobile!, "fileext": "MOV", "filetype": "2", "applicantId": String(userinfo.beisen_id!) ]
            print(param)
            for (key, value) in param {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
            
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON{ response in
                        HUD.hide()
                        
                        print(response)
                        if(response.result.value != nil && response.result.isSuccess){
                            let json = SwiftyJSON.JSON(response.result.value!)
                            debugPrint(json)
                            if let url = json["url"].string {
                                self.delegate2?.updateVideoUrl(url)
                            }
                            
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
        let compatiblePresets = AVAssetExportSession.exportPresetsCompatibleWithAsset(avAsset)
        if compatiblePresets.contains(AVAssetExportPreset640x480){
            let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPreset640x480)
            
            let formater = NSDateFormatter()
            formater.dateFormat = "yyyyMMddHHmmss"
            let filename = "video\(formater.stringFromDate(NSDate())).mp4"
            let resultPath = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
            let outputURL = NSURL(string: resultPath)
            
            exportSession!.outputURL = outputURL
            exportSession!.outputFileType = AVFileTypeMPEG4
            exportSession!.shouldOptimizeForNetworkUse = true
            exportSession!.exportAsynchronouslyWithCompletionHandler({
                switch (exportSession!.status) {
                case .Failed:
                    print("视频压缩失败")
                    print("failed \(exportSession!.error)")
                case .Completed:
                    print("视频压缩成功")
                    print("cancelled \(exportSession!.error)")
                    
                default:
                    print("default")
                }
            })

        }
    }
    
    func convertVideoWithMediumQuality(inputURL : NSURL){
        
        //let VideoFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("mergeVideo\(arc4random()%1000)d").URLByAppendingPathExtension("mp4").absoluteString
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyyMMddHHmmss"
        let filename = "video\(formater.stringFromDate(NSDate())).mp4"
        let VideoFilePath = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        
        if NSFileManager.defaultManager().fileExistsAtPath(VideoFilePath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(VideoFilePath)
            } catch { }
        }
        
        let savePathUrl =  NSURL(string: VideoFilePath)!
        
        let sourceAsset = AVURLAsset(URL: inputURL, options: nil)
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetMediumQuality)!
        assetExport.outputFileType = AVFileTypeMPEG4 //AVFileTypeQuickTimeMovie
        assetExport.outputURL = savePathUrl
        assetExport.exportAsynchronouslyWithCompletionHandler { () -> Void in
            
            switch assetExport.status {
            case AVAssetExportSessionStatus.Completed:
                dispatch_async(dispatch_get_main_queue(), {
                    do {
                        let videoData = try NSData(contentsOfURL: savePathUrl, options: NSDataReadingOptions())
                        print("MB - \(videoData.length / (1024 * 1024))")
                    } catch {
                        print(error)
                    }
                    
                })
            case  AVAssetExportSessionStatus.Failed:
                print("failed \(assetExport.error)")
            case AVAssetExportSessionStatus.Cancelled:
                print("cancelled \(assetExport.error)")
            default:
                print("complete")
            }
        }
        
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
