//
//  ClinicCell.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class ClinicCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCellWithClinic(clinic: Clinic) {
        self.name.text = clinic.name
        self.address.text = clinic.address
    }
    
    class func calculateCellHeigh(str: String) -> CGFloat {
        var lb = UILabel(frame: CGRectMake(0, 0, SCREEN_SIZE.width - 52, 200))
        lb.numberOfLines = 0
        lb.font = UIFont.systemFontOfSize(15)
        lb.text = str
        lb.sizeToFit()
        if lb.frame.size.height < 21 {
            return 51
        }
        return lb.frame.size.height + 30
    }
    
}
