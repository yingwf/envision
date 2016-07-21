//
//  MessageTableViewController.swift
//  envision
//
//  Created by  ywf on 16/7/12.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageTableViewController: UITableViewController {

    
    var messages = [Message]()
    let messageCell = "MessageTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setBackButton()
        
        
        self.tableView.tableFooterView = UIView() //取消多余的分割线
        self.tableView.backgroundColor = BACKGROUNDCOLOR
        self.tableView.registerNib(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: messageCell)
        self.tableView.estimatedRowHeight = 73.0
        self.tableView.rowHeight =  UITableViewAutomaticDimension
        
        
        HUD.show(.RotatingImage(loadingImage))
        let seedUrl = getMessageList
        let parameters = ["applicantId":userinfo.beisen_id!]
        doRequest(seedUrl, parameters: parameters, encoding: .URL, praseMethod: praseMessageList)
    }
    
    func praseMessageList(json: SwiftyJSON.JSON){
        if json["success"].boolValue {
            if let data = json["news"].array{
                if data.count > 0{
                    for index in 0...data.count - 1{
                        let message = Message()
                        message.getMessageInfo(data[index])
                        self.messages.append(message)
                    }
                }
                self.tableView.reloadData()
            }
        }
        HUD.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(messageCell, forIndexPath: indexPath) as! MessageTableViewCell
        cell.title.text = self.messages[indexPath.row].title
        cell.content.text = self.messages[indexPath.row].content
        cell.content.sizeToFit()
        if let isRead = self.messages[indexPath.row].isRead{
            cell.redDot.hidden = isRead
        }
        if let sendTime = self.messages[indexPath.row].sendTime {
            let formater = NSDateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            let nowDate = formater.stringFromDate(NSDate())
            let sendDate = getDateFromString(sendTime)
            var displayTime: String?
            
            if nowDate == sendDate {
                displayTime = "今天"
            }else{
                displayTime = getMonthAndDayFromString(sendDate)
            }
            cell.sendTime.text = displayTime
        }

        return cell
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 73
//    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.messages[indexPath.row].isRead != nil && !self.messages[indexPath.row].isRead!{
            self.messages[indexPath.row].isRead = true
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
