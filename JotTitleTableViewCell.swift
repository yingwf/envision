//
//  JotTitleTableViewCell.swift
//  envision
//
//  Created by  ywf on 16/6/30.
//  Copyright © 2016年 yingwf. All rights reserved.
//

import UIKit

class JotTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var kind: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var collectImage: UIImageView!
    @IBOutlet weak var major: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let width = UIScreen.mainScreen().bounds.width
        let sepView = UIView(frame: CGRect(x: 16, y: 88, width: width - 32, height: 0.5))
        sepView.backgroundColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
        self.contentView.addSubview(sepView)
        
        let sepView2 = UIView(frame: CGRect(x: 16, y: 190, width: width - 32, height: 0.5))
        sepView2.backgroundColor = UIColor(red: 0xe5/255, green: 0xe5/255, blue: 0xe5/255, alpha: 1)
        self.contentView.addSubview(sepView2)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
