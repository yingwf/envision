//
//  ShareView.swift
//  envision
//
//  Created by  ywf on 16/6/1.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class ShareView: UIView {

    @IBOutlet weak var weChatFriend: UIView!
    @IBOutlet weak var friendCircle: UIView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let width = UIScreen.mainScreen().bounds.width
        let sepeView = UIView(frame: CGRect(x: 0, y: 115, width: width, height: 0.5))
        sepeView.backgroundColor = SEPERATORCOLOR
        self.addSubview(sepeView)

    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
