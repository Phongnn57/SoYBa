//
//  VaccineCell.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 9/1/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class VaccineCell: UITableViewCell {

    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCellWithVaccine(vaccine: Vaccine) {
        if vaccine.isSelect {
            self.check.image = UIImage(named: "check")
        } else {
            self.check.image = UIImage(named: "uncheck")
        }
        self.name.text = vaccine.sick.sickName
    }
    
}
