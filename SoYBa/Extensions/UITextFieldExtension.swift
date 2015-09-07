//
//  UITextFieldExtension.swift
//  Rongbay
//
//  Created by Ngo Ngoc Chien on 5/20/15.
//  Copyright (c) 2015 Ngo Ngoc Chien. All rights reserved.
//

import UIKit
import Foundation

extension UITextField {
    
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return 0
        }
        set (padding) {
            layer.sublayerTransform = CATransform3DMakeTranslation(padding, 0, 0)
        }
    }
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            return UIColor.clearColor()
        }
        set (color) {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder ?? "",
                attributes:[NSForegroundColorAttributeName:color])
        }
    }
    
    func string() -> String {
        return self.text ?? ""
    }
}
