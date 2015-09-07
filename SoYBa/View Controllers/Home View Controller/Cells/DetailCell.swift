//
//  DetailCell.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var count: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configCellWithPatientInjection(patientInjection: Patient_Injection) {
        let sick = Sick.MR_findFirstWithPredicate(NSPredicate(format: "id = \(patientInjection.sickID)")) as! Sick
        self.name.text = sick.sickName
        self.time.text = patientInjection.inject_day.toString()
        self.count.text = "Mũi thứ " + "\(patientInjection.number)"
    }
    
    class func calculateCellHeigh(str: String) -> CGFloat {
        var lb = UILabel(frame: CGRectMake(0, 0, SCREEN_SIZE.width - 54, 200))
        lb.numberOfLines = 0
        lb.font = UIFont.systemFontOfSize(17)
        lb.text = str
        lb.sizeToFit()
        if lb.frame.size.height < 21 {
            return 60
        }
        return lb.frame.size.height + 31
    }
    
}
