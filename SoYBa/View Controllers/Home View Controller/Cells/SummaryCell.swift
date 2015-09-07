//
//  SummaryCell.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

protocol SummaryCellDelegate {
    func didSelectButtonAtCellAndIndex(cell: SummaryCell, btnIndex: Int)
}

class SummaryCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    var delegate: SummaryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellWithSick(injections: Array<Patient_Injection>) {
        
        for obj in self.subviews {
            if obj.isKindOfClass(UIButton) {
                obj.removeFromSuperview()
            }
        }
        
        
        
        for var i = 0; i < injections.count; i++ {
            let sickID = injections[i].sickID
            let sickCount = injections[i].number
            let sick = Sick.MR_findFirstWithPredicate(NSPredicate(format: "id = \(sickID)")) as! Sick
            self.name.text = sick.sickName
            println(self.name.text)
            var button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            button.frame = CGRectMake(96.0 + 32.0 * CGFloat(i), 14, 24, 24)
            
            let currentDay = NSDate()
            
            if injections[i].inject_day.isAfter(currentDay) {
                button.setImage(UIImage(named: "inject_incomming"), forState: .Normal)
                
            } else {
                if injections[i].isDone.integerValue == 1 {
                    button.setImage(UIImage(named: "inject_done"), forState: .Normal)
                } else {
                    button.setImage(UIImage(named: "inject_miss"), forState: .Normal)
                }
                
            }
            
            button.tag = i
            button.addTarget(self, action: "didSelectButton:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.addSubview(button)
        }
    }
    
    func didSelectButton(btn: UIButton) {
        self.delegate?.didSelectButtonAtCellAndIndex(self, btnIndex: btn.tag)
    }
    
}
