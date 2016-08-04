//
//  StarView.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class StarView: UIView {

    var star: Int = 5
    
    var starArray = [UIView]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setStar()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.setStar()
    }
    
    func setResult(star: Int) {
        if star < 0 {
            self.star = 0
        }else if star > 5 {
            self.star = 5
        }else {
            self.star = star
        }
        for index in 0...4 {
            if index <= self.star - 1 {
                (starArray[index].subviews.first as! UIImageView).image = UIImage(named:"starY")
            }else{
                (starArray[index].subviews.first as! UIImageView).image = UIImage(named:"starG")
            }
        }
    }
    
    func setStar(){
        
        let height = self.frame.height
        
        for index in 0...4 {
            let starView = UIView(frame: CGRect(x: 31 * index, y: 0, width: 31, height: Int(height)))
            
            let starImage = UIImageView(frame: CGRect(x: 8, y: Int((height - 14)/2), width: 15, height: 14))
            starImage.image = UIImage(named: "starY")
            starView.addSubview(starImage)
            starView.tag = index

            let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
            starView.userInteractionEnabled = true
            starView.addGestureRecognizer(tap)
            tap.view!.tag = index
            self.addSubview(starView)
            self.starArray.append(starView)
        }
        
    }

    
    func tapAction(sender: UITapGestureRecognizer){

        if let tag = sender.view?.tag{
            if tag == 0 && self.star == 1{
                //当前是1星，再次点击时归0
                (starArray[0].subviews.first as! UIImageView).image = UIImage(named:"starG")
                self.star = 0
                return
            }
            
            for var index = 0; index <= tag; index++ {
                (starArray[index].subviews.first as! UIImageView).image = UIImage(named:"starY")
            }
            if tag < 4{
                for var index = tag + 1; index <= 4; index++ {
                    (starArray[index].subviews.first as! UIImageView).image = UIImage(named:"starG")
                }
            }
            
            self.star = tag + 1
            
        }
        
        
    }

}
