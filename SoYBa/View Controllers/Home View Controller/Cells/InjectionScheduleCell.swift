//
//  InjectionScheduleCell.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class InjectionScheduleCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var count: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWithInjection(injectionSchedule: Injection_Schedule) {
        let sick = Sick.MR_findFirstWithPredicate(NSPredicate(format: "id = \(injectionSchedule.sick)")) as! Sick
        self.name.text = sick.sickName
        self.count.text = "Mũi thứ " + "\(injectionSchedule.number)"
    }
    
    class func calculateCellHeigh(str: String) -> CGFloat {
        var lb = UILabel(frame: CGRectMake(0, 0, SCREEN_SIZE.width - 130, 200))
        lb.numberOfLines = 0
        lb.font = UIFont.systemFontOfSize(17)
        lb.text = str
        lb.sizeToFit()
        if lb.frame.size.height < 21 {
            return 40
        }
        return lb.frame.size.height + 16
    }
    
}
