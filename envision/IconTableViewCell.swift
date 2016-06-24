//
//  IconTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/5/29.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class IconTableViewCell: UITableViewCell {

    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    
    @IBOutlet weak var leftArrow2: UIImageView!
    @IBOutlet weak var rightArrow2: UIImageView!
    
    @IBOutlet weak var testVideoView: UIView!
    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var recordVideoView: UIView!
    
    @IBOutlet weak var applyView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let width = UIScreen.mainScreen().bounds.width
        
        let seperateView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0.5))
        seperateView.backgroundColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
        self.testVideoView.addSubview(seperateView)
        
        let verticalView = UIView(frame: CGRect(x: width/2, y: 0, width: 0.5, height: 150))
        verticalView.backgroundColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
        self.testVideoView.addSubview(verticalView)
        
        self.testView.layer.borderWidth = 0.5
        self.testView.layer.borderColor = SYSTEMCOLOR.CGColor
        
        self.videoView.layer.borderWidth = 0.5
        self.videoView.layer.borderColor = SYSTEMCOLOR.CGColor
        
//        UIView.animateWithDuration(0.8,
//            delay:0.5,
//            usingSpringWithDamping: 0.8,
//            initialSpringVelocity: 0.3,
//            options: [.Repeat,.CurveEaseInOut],
//            animations: {
//                self.leftArrow.frame = self.leftArrow.frame.offsetBy(dx: 15, dy: 0)
//            },
//            completion: nil)
//        
//        UIView.animateWithDuration(0.8,
//            delay:0.5,
//            usingSpringWithDamping: 0.8,
//            initialSpringVelocity: 0.3,
//            options: [.Repeat,.CurveEaseInOut],
//            animations: {
//                self.rightArrow.frame = self.rightArrow.frame.offsetBy(dx: -15, dy: 0)
//            },
//            completion: nil)
//        UIView.animateWithDuration(0.8,
//            delay:0.5,
//            usingSpringWithDamping: 0.8,
//            initialSpringVelocity: 0.3,
//            options: [.Repeat,.CurveEaseInOut],
//            animations: {
//                self.leftArrow2.frame = self.leftArrow2.frame.offsetBy(dx: 15, dy: 0)
//            },
//            completion: nil)
//        
//        UIView.animateWithDuration(0.8,
//            delay:0.5,
//            usingSpringWithDamping: 0.8,
//            initialSpringVelocity: 0.3,
//            options: [.Repeat,.CurveEaseInOut],
//            animations: {
//                self.rightArrow2.frame = self.rightArrow2.frame.offsetBy(dx: -15, dy: 0)
//            },
//            completion: nil)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
