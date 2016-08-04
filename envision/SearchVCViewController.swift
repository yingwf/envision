//
//  SearchVCViewController.swift
//  envision
//
//  Created by  ywf on 16/6/13.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchVCViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchText:String = ""
    var searchCount = 0
    var dataArray: [String] =  []
    
    var isSearchSchool = true //默认搜索学校，否则搜索专业
    var delegate: updateInfoDelegate?
    var indexPath = NSIndexPath(forRow: 0, inSection: 0) //表示更新哪一行的信息
    
    
    override func viewWillAppear(animated: Bool) {
        self.searchBar.tintColor = UIColor.whiteColor()
        
        let view: UIView = self.searchBar.subviews[0]
        let subViewsArray = view.subviews
        
        for subView in subViewsArray {
            if subView.isKindOfClass(UITextField){
                subView.tintColor = SYSTEMCOLOR
                subView.layer.cornerRadius = 14
                subView.layer.masksToBounds = true
            }
        }
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: CGRect(x: 0,y: 0,width: UIScreen.mainScreen().bounds.width,height: 20))
        statusBarView.backgroundColor = SYSTEMCOLOR
        self.view.addSubview(statusBarView)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        

        self.searchBar.delegate = self
        if isSearchSchool {
            self.searchBar.placeholder = "请输入学校名称"
        }else{
            self.searchBar.placeholder = "请输入专业名称"
        }
        self.searchBar.becomeFirstResponder()
        
        self.searchCount = Int(self.tableView.frame.height/44)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.tableView.registerClass(UITableViewCell.self,forCellReuseIdentifier: "idCell")
        let view = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = view
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    // 返回表格行数（也就是返回控件数）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
  
    // 创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) 
        
        let labelString: NSString = dataArray[indexPath.row]
        let range = labelString.rangeOfString(self.searchText)
        
        let attributedStr = NSMutableAttributedString(string: dataArray[indexPath.row])
        attributedStr.addAttribute(NSForegroundColorAttributeName, value: SYSTEMCOLOR, range: range)
        
        cell.textLabel?.attributedText = attributedStr
        
        return cell
    }
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        
//        if (searchText as NSString).length < (self.searchText as NSString).length{
//            //回退时不搜索
//            return
//        }
//        let url =  searchAcademy
//        let param = ["keyword":searchText ,"count":self.searchCount] as [String : AnyObject]
//        afRequest(url, parameters: param, encoding: .URL, praseMethod: praseSearchResult)
//        
//    }
    
    func praseSearchResult(json: SwiftyJSON.JSON){
        
        if json["success"].boolValue {
            var  result = json["SpecialtyList"].array
            if isSearchSchool{
                result = json["AcademyList"].array
            }
            self.dataArray.removeAll(keepCapacity: true)

            if result?.count > 0 {
                for index in 0...result!.count - 1{
                    self.dataArray.append(result![index]["value"].string!)
                }
            }
            self.tableView.reloadData()
            
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        self.searchText = searchText
        self.searchBar.resignFirstResponder()
        var url = searchSpecialty
        if isSearchSchool {
            url =  searchAcademy
        }
        let param = ["keyword":searchText ,"count":self.searchCount] as [String : AnyObject]
        afRequest(url, parameters: param, encoding: .URL, praseMethod: praseSearchResult)
    }
    
    
    
    // 搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        if (searchText as NSString).length < (self.searchText as NSString).length{
//            //回退时不搜索
//            return
//        }
//        self.searchText = searchText
//        self.searchBar.resignFirstResponder()
//        var url = searchSpecialty
//        if isSearchSchool {
//            url =  searchAcademy
//        }
//        if searchText.isEmpty {return}
//        let param = ["keyword":searchText ,"count":self.searchCount] as [String : AnyObject]
//        afRequest(url, parameters: param, encoding: .URL, praseMethod: praseSearchResult)
//        
//
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let info = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
        if info == nil {
            return
        }
        self.delegate?.updateInfo(self.indexPath, info: info!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
