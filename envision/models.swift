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
var myTableViewController: MyTableViewController?
var myApplyTableViewController: MyApplyTableViewController?
let loadingImage = UIImage(named: "loadingLogo")
var deviceId: String? //apns token
var isFromMyInterview = false //标示是否从“我的应聘”页面进入选择职位
var INTERVIEWID: Int? //当前面试任务id
var roomInfo: RoomInfo? //当前面试官房间信息

//种子信息
class SeedInfo {
    var id: Int?
    var content: String?
    var title: String?
    var school: String?
    var department: String?
    var name: String?
    var image: String?
    func getInfo(json: SwiftyJSON.JSON){
        self.id = json["seedId"].int
        self.image = json["image"].string
    }
}


class CvInfo {
    var applicantId: Int?
    var name: String?
    var img: String?
    var lastschool: String?
    var ElinkUrl: String?
    
    func getCvInfo(json: SwiftyJSON.JSON){
        self.applicantId = json["applicantId"].int
        self.name = json["name"].string
        self.img = json["img"].string
        self.lastschool = json["lastschool"].string
        self.ElinkUrl = json["ElinkUrl"].string
    }
}

//用户信息
class UserInfo {
    var id : Int?
    var identity: String?
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
    var employeeid: Int?
    var jobId: Int?
    
    func getUserInfo(json: SwiftyJSON.JSON){
        let applicant = json["userinfo"].dictionary!
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
        self.identity = applicant["IDcard"]?.string
    }
    func haveCV() -> Bool{
        //判断是否已填写微简历
        var hasInputed = false
        if self.gender != "" && self.educationLevel != "" && self.lastschool != "" && self.lastDisciplineKind != "" && self.graduationDate != "" {
            hasInputed = true
        }
        return hasInputed
    }
}


class Job {
    var jobid: Int?
    var address: String?
    var MBYZ: String?
    var MBRQ: String?
    var jobTitle: String?
    var kind: String?
    var Duty: String?
    var Requiremnet: String?
    var isCollect: Bool? = false //默认未收藏
    var seedList = [SeedInfo]()
    func getJobInfo(json: SwiftyJSON.JSON){
        self.jobid = json["jobid"].int
        self.address = json["address"].string
        self.MBYZ = json["MBYZ"].string
        self.jobTitle = json["jobTitle"].string
        self.kind = json["kind"].string
        self.Duty = json["Duty"].string
        self.Requiremnet = json["Requiremnet"].string
        self.isCollect = json["isCollect"].bool
        let seedList = json["seedList"].array
        if seedList != nil && seedList!.count > 0{
            for index in 0...seedList!.count - 1{
                let seedInfo = SeedInfo()
                seedInfo.getInfo(seedList![index])
                self.seedList.append(seedInfo)
            }
        }
        
    }
}

class JobList {
    var ZWFL: String?
    var jobs: [Job] = []
    func getJobList(json: SwiftyJSON.JSON){
        self.ZWFL = json["ZWFL"].string
        let count = json["joblist"].array?.count
        if count != nil && count > 0{
            for index in 0...count! - 1{
                let job = Job()
                job.getJobInfo(json["joblist"][index])
                self.jobs.append(job)
            }
        }
    }
}

class InterviewInfo {
    var id: Int?
    var endTime: String?
    var startTime: String?
    var location: String?
    var number: String?
    var allNumber: String?
    func getInterviewInfo(json: SwiftyJSON.JSON){
        self.id = json["id"].int
        self.endTime = json["endtime"].string
        self.startTime = json["starttime"].string
        self.location = json["loc"].string
        self.number = json["number"].string
        self.allNumber = json["allnumber"].string
    }
    func getInterViewTime() -> String{
        var interviewTime = ""
        if self.startTime != nil && self.endTime != nil {
            interviewTime = getDateFromString(self.startTime!)! + " | " + getTimeFromString(self.startTime!)! + "-" + getTimeFromString(self.endTime!)!
        }

        return interviewTime
    }
}

class LineInfo {
    //排队信息
    var lineNumber: Int?
    var count: Int?
    var nowLineNumber: Int?
    var interviewNumber: Int?
    func getLineInfo(json: SwiftyJSON.JSON){
        self.lineNumber = json["lineNumber"].int
        self.count = json["count"].int
        self.nowLineNumber = json["nowLineNumber"].int
        self.interviewNumber = json["interviewNumber"].int
    }
}

class MyInterView {
    var interviewId: Int?
    var duration: Int?
    var location: String?
    var job: String?
    var time: String?
    var date: String?
    var personAmount: Int?
    
    func getMyInterView(json: SwiftyJSON.JSON){
        self.interviewId = json["interviewId"].int
        self.duration = json["Duration"].int
        self.location = json["interviewLocName"].string
        self.job = json["job"].string
        self.time = json["time"].string
        self.date = json["interviewDate"].string
        self.personAmount = json["PersonAmount"].int
    }
}

class Message {
    var title: String?
    var content: String?
    var sendTime: String?
    var isRead: Bool?
    func getMessageInfo(json: SwiftyJSON.JSON){
        self.title = json["title"].string
        self.content = json["content"].string
        self.sendTime = json["sendtime"].string
        self.isRead = json["isread"].bool
    }
}

class RoomInfo {
    var interviewName: String?
    var roomNo: String?
    var deskNo: String?
    func getInfo(json: SwiftyJSON.JSON){
        self.roomNo = json["roomNo"].string
        self.deskNo = json["deskNo"].string
        self.interviewName = json["interviewName"].string
    }
}

class ApplicantInterview {
    var interviewPhase: Int?
    var interviewStatus: Int?
    var jobInfo: Job?
    var interviewInfo: InterviewInfo?
    var lineInfo: LineInfo?
    var roomInfo: RoomInfo?
    func getInfo(json: SwiftyJSON.JSON){
        self.interviewPhase = json["interviewPhase"].int
        self.interviewStatus = json["interviewStatus"].int
        if json["jobInfo"] != nil{
            self.jobInfo = Job()
            self.jobInfo!.getJobInfo(json["jobInfo"])
        }
        if json["interviewInfo"] != nil{
            self.interviewInfo = InterviewInfo()
            self.interviewInfo!.getInterviewInfo(json["interviewInfo"])
        }
        if json["lineInfo"] != nil{
            self.lineInfo = LineInfo()
            self.lineInfo!.getLineInfo(json["lineInfo"])
        }
        if json["roomInfo"] != nil{
            self.roomInfo = RoomInfo()
            self.roomInfo!.getInfo(json["roomInfo"])
        }
    }
}

class InterviewProgress {
    var applicantId: Int?
    var ElinkUrl: String?
    var waitApplicant: Int?
    var interviewedApplicant: Int?
    var passedApplicant: Int?
    var passedRate: String?
    var totalPassedRate: String?
    
    
    func getInfo(json: SwiftyJSON.JSON){
        self.applicantId = json["applicantId"].int
        self.ElinkUrl = json["ElinkUrl"].string
        self.waitApplicant = json["waitApplicant"].int
        self.interviewedApplicant = json["interviewedApplicant"].int
        self.passedApplicant = json["passedApplicant"].int
        self.passedRate = json["passedRate"].string
        self.totalPassedRate = json["totalPassedRate"].string
    }
}

