//
//  VideoPlayViewController.swift
//  envision
//
//  Created by  ywf on 16/8/17.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVKit
import AVFoundation

class VideoPlayViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UpdateVideoUrlDelegate {

    var url: String?
    var playerController = AVPlayerViewController()
    var player = AVPlayer()
    var imagePickerController: YJImagePickerController?
    
    @IBOutlet weak var movieView: UIView!
    
    @IBOutlet weak var beginPlay: UIImageView!
    
    @IBOutlet weak var videoRecordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.beginPlay.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(moviePlay))
        self.beginPlay.addGestureRecognizer(tap)
        
        
        self.videoRecordView.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoRecord))
        self.videoRecordView.addGestureRecognizer(tapRecognizer)
        
        guard let url = url else {
            return
        }
        
        self.player = AVPlayer(URL: NSURL(string: url)!)
        playerController.player = player
        self.addChildViewController(playerController)
        self.movieView.addSubview(playerController.view)
        playerController.view.frame = self.movieView.bounds
        
        self.setBackButton()
        
    }
    
    func updateVideoUrl(url: String) {
        self.url = url
        
        self.player = AVPlayer(URL: NSURL(string: url)!)
        playerController.player = player
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
        imagePickerController!.delegate = self
        imagePickerController!.delegate2 = self
        self.presentViewController(imagePickerController!, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imagePickerController?.saveVideo(info)
    }
    
    
    func moviePlay() {
        player.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
