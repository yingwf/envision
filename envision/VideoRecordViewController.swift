//
//  VideoRecordViewController.swift
//  envision
//
//  Created by  ywf on 16/8/17.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

protocol UpdateVideoUrlDelegate: NSObjectProtocol {
    func updateVideoUrl(url: String)
}


class VideoRecordViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UpdateVideoUrlDelegate {

    var imagePickerController: YJImagePickerController?

    @IBOutlet weak var videoRecordView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.videoRecordView.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoRecord))
        self.videoRecordView.addGestureRecognizer(tapRecognizer)
        self.setBackButton()
    }
    
    func updateVideoUrl(url: String) {
        let videoPlayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("VideoPlayViewController") as! VideoPlayViewController
        videoPlayViewController.url = url
        self.navigationController?.pushViewController(videoPlayViewController, animated: true)
    }

    func videoRecord() {
        //录制视频
        imagePickerController = YJImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(.Camera){
            
            let alertView = UIAlertController(title: "提醒", message: "摄像头不可用，请在设置中打开摄像头权限", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "确定", style: .Default) {(UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return
        }
        imagePickerController?.delegate = self
        imagePickerController?.delegate2 = self
        self.presentViewController(imagePickerController!, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imagePickerController?.saveVideo(info)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
