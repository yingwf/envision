//
//  RNCalScrollView.swift
//  envision
//
//  Created by  ywf on 16/8/4.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class RNCalScrollView: UIView ,UIScrollViewDelegate {
    private var timer: NSTimer?
    private var sourceArr = [String]()
    private var scrollView: UIScrollView?
    private var pageControl: UIPageControl?
    internal var delegate: UIScrollViewDelegate?
    private let count = 4
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sourceArr = []
        self.initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.sourceArr = []
        self.initSubViews()
        
    }
    
    internal func initWithImgs(imageViews: [String]){
        self.sourceArr = imageViews
        self.userInteractionEnabled = true
        self.initSubViews()
    }
    
    private func initSubViews(){
        
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        if scrollView != nil {
            scrollView?.removeFromSuperview()
            scrollView = nil
        }
        self.scrollView = UIScrollView(frame:self.frame)
        self.scrollView!.scrollsToTop = false
        self.scrollView!.userInteractionEnabled = true
        self.scrollView!.delegate = self
        self.scrollView!.pagingEnabled = true
        self.scrollView!.contentSize = CGSizeMake(width * CGFloat(count), height)
        self.scrollView!.showsVerticalScrollIndicator = false
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView!)
        
        
        var nowDateTime = NSDate()
        let weekDay = nowDateTime.dayOfWeek()
        let weekDayTitle = ["S","M","T","W","T","F","S"]
        var days = [NSArray]()
        let dateFmt = NSDateFormatter()
        dateFmt.dateFormat = "YYYY-MM-DD"
        for index in 0...27 {
            let nextDateTime = nowDateTime.dateByAddingTimeInterval(NSTimeInterval(index * 24 * 3600))//增加一天
            let dateString = dateFmt.stringFromDate(nextDateTime)
            let dateTimeArray = dateString.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "-"))
            days.append(dateTimeArray)
        }
        
        let dayWidth = Int(width/7)
        
        for index in 0 ... count - 1 {
            let calView = UIView()
            calView.frame = CGRectMake(width * CGFloat(index + 1), 0, width, height)
            calView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            
            for day in 0 ... 6 {
                let dayTitle = UILabel(frame: CGRect(x: day * dayWidth + dayWidth/2, y: 10, width: dayWidth, height: 10))
                dayTitle.font = UIFont.systemFontOfSize(10)
                dayTitle.textColor = UIColor.whiteColor()
                dayTitle.text = weekDayTitle[(weekDay + day) % 7]
                calView.addSubview(dayTitle)
                
                let dateNum = UILabel(frame: CGRect(x: day * dayWidth + dayWidth/2, y: 30, width: 35, height: 35))
                dateNum.text = days[index * 7 + day][2] as! String
                dateNum.font = UIFont.systemFontOfSize(14)
                calView.addSubview(dateNum)
            }

            self.scrollView!.addSubview(calView)
            
        }
        
        if self.pageControl != nil{
            self.pageControl?.removeFromSuperview()
            self.pageControl = nil
        }
        self.pageControl = UIPageControl(frame:CGRectMake(0, height-20, width, 20))
        self.pageControl!.numberOfPages = sourceArr.count
        self.pageControl!.currentPage = 0
        self.pageControl!.enabled = true
        self.pageControl!.currentPageIndicatorTintColor = UIColor(red: 0, green: 0xa6/255, blue: 0xdb/255, alpha: 1)
        self.pageControl!.pageIndicatorTintColor = UIColor(red: 0x62/255, green: 0x6c/255, blue: 0x73/255, alpha: 1)
        //设置页控件点击事件
        self.pageControl!.addTarget(self, action: "pageChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.addSubview(self.pageControl!)
        
        self.scrollView!.scrollEnabled=true
        
    }

    
    //点击页控件时事件处理
    func pageChanged(sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        var frame = self.scrollView!.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage + 1)
        frame.origin.y = 0
        //展现当前页面内容
        scrollView!.scrollRectToVisible(frame, animated:true)
    }
    
    
}


extension NSDate {
    
    func dayOfWeek() -> Int {
        let interval = self.timeIntervalSince1970
        let days = Int(interval / 86400)
        return (days - 3) % 7 //week为整形，从0到6分别表示 周日 到周六
    }
}
