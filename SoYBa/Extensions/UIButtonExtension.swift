//
//  UIButtonExtension.swift
//  Enbac
//
//  Created by Nguyen Tien Dung on 7/10/15.
//  Copyright © 2015 Hoang Duy Nam. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    @IBInspectable var autoScare: Bool {
        get {
            return false
        }
        set (autoScare) {
            self.titleLabel?.minimumScaleFactor = 0.5
        }
    }
}