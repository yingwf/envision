//
//  SendTitleTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/7/1.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class SendTitleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var academy: UILabel!
    @IBOutlet weak var telephone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var identity: UILabel!
    @IBOutlet weak var editView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.genderView.layer.cornerRadius = 3
        self.genderView.layer.masksToBounds = true
        
    }
    
    func setInfo(){
        self.name.text = userinfo.name
        self.name.sizeToFit()
        self.gender.text = userinfo.gender
        if userinfo.gender == "男"{
            self.genderImage.image = UIImage(named: "man")
        }else{
            self.genderImage.image = UIImage(named: "woman")
        }
        self.school.text = userinfo.lastschool
        if userinfo.graduationDate != nil && userinfo.educationLevel != nil && userinfo.lastDisciplineKind != nil{
            self.academy.text = "\(userinfo.graduationDate!)年 | \(userinfo.educationLevel!) | \(userinfo.lastDisciplineKind!)"
        }
        self.telephone.text = userinfo.mobile
        self.email.text = userinfo.email
        self.identity.text = userinfo.identity
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
