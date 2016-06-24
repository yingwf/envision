//
//  YYPickerView.swift
//  envision
//
//  Created by  ywf on 16/6/7.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class YYPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    
    var backgroundView: UIView?
    var pickerView: UIPickerView?
    var graduateYear = [String]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    
    
    func show(){
        
        
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: height, width: width, height: 210))
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerView?.backgroundColor = BACKGROUNDCOLOR
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let thisYear = dateFormatter.stringFromDate(NSDate())
        pickerView?.selectRow(Int(thisYear)! - 2010, inComponent: 0, animated: false)
        
        //增加确认按钮
        let btn = UIButton(frame: CGRect(x: 0, y: 210, width: width, height: 40))
        btn.setTitle("确定", forState: .Normal)
        btn.setTitleColor(SYSTEMCOLOR, forState: .Normal)
        btn.addTarget(self, action: "selectGraduate:", forControlEvents: .TouchUpInside)
        
        backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
        backgroundView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        let tapGR = UITapGestureRecognizer(target: self, action: "tapCancel")
        self.backgroundView!.userInteractionEnabled = true
        self.backgroundView!.addGestureRecognizer(tapGR)
        backgroundView!.addGestureRecognizer(tapGR)
        
        backgroundView!.addSubview(btn)
        backgroundView!.addSubview(pickerView!)
            
        UIApplication.sharedApplication().keyWindow?.addSubview(backgroundView!)
        
        UIView.animateWithDuration(0.15, animations: {
            
            self.pickerView!.frame = CGRect(x: 0, y: 0, width: width, height: 210)
            self.backgroundView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
        })
  
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.graduateYear[row]
    }
    
    
    func tapCancel(){
        self.backgroundView!.removeFromSuperview()
        self.backgroundView = nil
    }
    
    func remove(sender:UIButton!){
        self.backgroundView!.removeFromSuperview()
        self.backgroundView = nil
        
    }
    


}
