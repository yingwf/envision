//
//  models.swift
//  SouTaiji
//
//  Created by  ywf on 16/4/17.
//  Copyright © 2016年  ywf. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

let SYSTEMCOLOR = UIColor(red: 0x00/255, green: 0xa6/255, blue: 0xdb/255, alpha: 1)
let BACKGROUNDCOLOR = UIColor(red: 0xf7/255, green: 0xf7/255, blue: 0xf7/255, alpha: 1)
let SEPERATORCOLOR  = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
var userinfo = UserInfo()
var myTableViewController = MyTableViewController()
let loadingImage = UIImage(named: "loadingLogo")


//种子信息
class SeedInfo {
    var id: Int?
    var content: String?
    var title: String?
    var school: String?
    var department: String?
    var name: String?
    var image: String?
}


//客户
class Customer {
    var name:String?
    var telephone1:String?
    var new_company:String?
    var new_position:String?
    var guid:String?
}

//用户信息
class UserInfo {
    var id : Int?
    var gender : String?
    var lastApplyDate : String?
    var version : Int?
    var mobile : String?
    var createDate : String?
    var educationLevel : String?
    var type : Int?
    var lastschool : String?
    var deviceId : String?
    var graduationDate : String?
    var image : String?
    var password : String?
    var lastDisciplineKind : String?
    var phoneType : Int?
    var email : String?
    var name : String?
    var beisen_id : Int?
    func getUserInfo(json: SwiftyJSON.JSON){
        let applicant = json["applicantProfile"].dictionary!
        self.id = applicant["id"]?.int
        self.gender = applicant["gender"]?.string
        self.lastApplyDate = applicant["lastApplyDate"]?.string
        self.version = applicant["version"]?.int
        self.mobile = applicant["mobile"]?.string
        self.createDate = applicant["createDate"]?.string
        self.educationLevel = applicant["educationLevel"]?.string
        self.type = applicant["type"]?.int
        self.lastschool = applicant["lastschool"]?.string
        self.deviceId = applicant["deviceId"]?.string
        self.graduationDate = applicant["graduationDate"]?.string
        self.image = applicant["image"]?.string
        self.password = applicant["password"]?.string
        self.lastDisciplineKind = applicant["lastDisciplineKind"]?.string
        self.phoneType = applicant["phoneType"]?.int
        self.email = applicant["email"]?.string
        self.name = applicant["name"]?.string
        self.beisen_id = applicant["beisen_id"]?.int
    }
}

//会馆
class ClubInfo {
    var image: String?
    var name: String?
    var liupai: String?
    var szSheng: String?
    var szShi: String?
    var szQu: String?
    var renzheng: String?
    var tel: String?
    
}


//教练
class CoachInfo {
    var image: String?
    var name: String?
    
}