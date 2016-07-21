//
//  EvaluateTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/28.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class EvaluateTableViewCell: UITableViewCell {

    var stars = [5,5,5,5]
    
    @IBOutlet weak var star1: StarView!
    @IBOutlet weak var star2: StarView!
    @IBOutlet weak var star3: StarView!
    @IBOutlet weak var star4: StarView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getResult() -> [Int]{
        stars[0] = star1.star
        stars[1] = star2.star
        stars[2] = star3.star
        stars[3] = star4.star
        return stars
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
