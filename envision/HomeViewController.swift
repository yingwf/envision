//
//  HomeViewController.swift
//  envision
//
//  Created by  ywf on 16/5/26.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HomeViewController: UITabBarController {
    
    let tabDefaultImageArray = ["home_off", "dream_off","my_off"]
    let tabSelectedImageArray = ["home_on", "dream_on","my_on"]
    let titleArray=["首页", "成为偏执狂","偏执狂中心"]
    let tabDefaultController = ["nav_DreamerViewController","nav_ApplyTableViewController","nav_MyTableViewController"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewController = self
        
        self.viewControllers = []
        for i in 0 ... tabDefaultController.count - 1{
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier(tabDefaultController[i])
            self.viewControllers?.append(controller!)
        }
        
        //设置为全局变量，方便刷新登录信息
        myTableViewController = (self.viewControllers?[2] as! UINavigationController).childViewControllers.first as! MyTableViewController

        
        // Do any additional setup after loading the view.
        if let items = self.tabBar.items{
            for i in 0 ... items.count - 1{
                
                var image:UIImage = UIImage(named: tabDefaultImageArray[i])!
                var selectedimage:UIImage = UIImage(named: tabSelectedImageArray[i])!
                let item = items[i]
                item.title = titleArray[i]
                item.setTitleTextAttributes([NSForegroundColorAttributeName :
                    UIColor(red: 0x90/255, green: 0x90/255, blue: 0x90/255, alpha: 0.44)], forState: UIControlState.Normal)
                item.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 0x00/255, green: 0xa6/255, blue: 0xdb/255, alpha: 1)], forState: UIControlState.Selected)
                
                image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                selectedimage = selectedimage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
                item.selectedImage = selectedimage
                item.image = image
                //item.imageInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
