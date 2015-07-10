
//
//  ActivityCell.swift
//  juryoku
//
//  Created by Joshua Book on 7/9/15.
//  Copyright (c) 2015 Boovius Projects. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var count: UIButton!
    @IBOutlet weak var doneLastAt: UILabel!
    @IBOutlet weak var activityTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.backgroundColor = UIColor.orangeColor()
        
        activityTitle.sizeToFit()
        let titleFrame = CGRect(x: 5, y: self.frame.height/2, width: self.frame.width - 20, height: self.frame.height/2)
        activityTitle.frame = titleFrame
        
        activityTitle.font = UIFont(name: "Verdana-Bold", size: 24)
        activityTitle.textColor = UIColor.whiteColor()
        activityTitle.numberOfLines = 0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}