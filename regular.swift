//
//  regular.swift
//  crm
//
//  Created by ywf on 16/5/6.
//  Copyright © 2016年 ying. All rights reserved.
//

import Foundation

public enum regularType {
    case telephone
    case email
    case idCard
}

func regularTest(textstring:String, type:regularType)->Bool{
    let telePattern = "^(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}$"
    let telePatternNumber = "[0-9]{11}"
    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let idCardPattern = "^[0-9]{15}$)|([0-9]{17}([0-9]|X)$"
    
    if(type == regularType.telephone){
        let last = textstring.rangeOfString(telePattern, options: NSStringCompareOptions.RegularExpressionSearch)
        let last1 = textstring.rangeOfString(telePatternNumber, options: NSStringCompareOptions.RegularExpressionSearch)
        
        
        if (last == nil || last1 == nil){
            return false
        }else{
            return true
        }
    }
    
    if(type == regularType.email){
        let last = textstring.rangeOfString(emailPattern, options: NSStringCompareOptions.RegularExpressionSearch)
        
        if (last == nil){
            return false
        }else{
            return true
        }
    }
    
    if(type == regularType.idCard){
//        let last = textstring.rangeOfString(idCardPattern, options: NSStringCompareOptions.RegularExpressionSearch)
//        
//        if (last == nil){
//            return false
//        }else{
//            return true
//        }
//        
//    }
//    return false
    
        return isValidIDCard(textstring)
    }
    return false

}

/// User ID Card
func isValidIDCard(cardno: NSString) -> Bool {
    if cardno.length != 18 {
        return false
    }
    
    let mmdd = "(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))"
    let leapMmdd = "0229"
    let year = "(19|20)[0-9]{2}"
    let leapYear = "(19|20)(0[48]|[2468][048]|[13579][26])"
    let yearMmdd = year + mmdd
    let leapyearMmdd = leapYear + leapMmdd
    let yyyyMmdd = "((\(yearMmdd))|(\(leapyearMmdd))|(20000229))"
    let area = "(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}"
    let regex = "\(area)\(yyyyMmdd)[0-9]{3}[0-9Xx]"
    
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    
    if predicate.evaluateWithObject(cardno) == false {
        return false
    }
    
    let chars = Array((cardno.uppercaseString).characters)

    let summary: Int = (chars[0].toInt()! + chars[10].toInt()!) * 7
        + (chars[1].toInt()! + chars[11].toInt()!) * 9
        + (chars[2].toInt()! + chars[12].toInt()!) * 10
        + (chars[3].toInt()! + chars[13].toInt()!) * 5
        + (chars[4].toInt()! + chars[14].toInt()!) * 8
        + (chars[5].toInt()! + chars[15].toInt()!) * 4
        + (chars[6].toInt()! + chars[16].toInt()!) * 2
        + chars[7].toInt()!
        + chars[8].toInt()! * 6
        + chars[9].toInt()! * 3
    
    let remainder = summary % 11
    let checkString = "10X98765432"
    
    let checkBit = Array(checkString.characters)[remainder]
    
    return (checkBit == chars.last)
}
extension Character {
    func toInt() -> Int? {
        return Int(String(self))
    }
}













