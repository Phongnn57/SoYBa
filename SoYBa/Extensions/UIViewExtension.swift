//
//  UIViewExtension.swift
//  Rongbay
//
//  Created by Ngo Ngoc Chien on 5/21/15.
//  Copyright (c) 2015 Ngo Ngoc Chien. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clearColor()
        }
        set (color) {
            self.layer.borderColor = color.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return 0
        }
        set (width) {
            self.layer.borderWidth = width
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return 0
        }
        set (width) {
            self.layer.cornerRadius = width
        }
    }
    @IBInspectable var _radius: CGFloat {
        get {
            return 0
        }
        set (_radius) {
            self.layer.cornerRadius = _radius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get { return UIColor(CGColor: self.layer.shadowColor ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor)! }
        set (color) { self.layer.shadowColor = color.CGColor }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return self.layer.shadowOffset }
        set (offset) { self.layer.shadowOffset = offset }
    }
    
    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(self.layer.shadowOpacity) }
        set (opacity) { self.layer.shadowOpacity = Float(opacity) }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return CGFloat(self.layer.shadowRadius) }
        set (radius) { self.layer.shadowRadius = radius }
    }
    
}

// MARK: - Animation Constants

private let BubbleControlMoveAnimationDuration: NSTimeInterval = 0.3
private let BubbleControlSpringDamping: CGFloat = 0.5
private let BubbleControlSpringVelocity: CGFloat = 0.2

