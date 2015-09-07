//
//  UIColorExtension.swift
//  Sổ Y Bạ
//
//  Created by Nam Phong on 7/16/15.
//  Copyright (c) 2015 Phong Nguyen Nam. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(_red: CGFloat, _green: CGFloat, _blue: CGFloat, _alpha: CGFloat) {
        let newRed = CGFloat(_red)/255.0
        let newGreen = CGFloat(_green)/255.0
        let newBlue = CGFloat(_blue)/255.0
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: _alpha)
    }
    
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = advance(rgba.startIndex, 1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.length) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", appendNewline: false)
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix", appendNewline: false)
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    //MARK: Darker color for highlighted button
    
    func darkerColorForColor(c: UIColor) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if c.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: max(r-0.2, 0.0), green: max(g-0.2, 0.0), blue: max(b-0.2, 0.0), alpha: a)
        }
        return c
    }

    
    //MARK: cutomize gradient background
    func theGradientBackground(backgroundView: UIView, hexColor1: String, hexColor2:String) -> UIView {
        
        let color1: UIColor = self.convertHexStringToColor(hexColor1)
        let color2: UIColor = self.convertHexStringToColor(hexColor2)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundView.bounds
        gradientLayer.colors = [color1.CGColor, color2.CGColor]
        backgroundView.layer.insertSublayer(gradientLayer, atIndex: 0)
        return backgroundView
    }

    func convertHexStringToColor (hexString: String) -> UIColor {
        var hexColorString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if hexColorString.hasPrefix("#") {
            hexColorString = hexColorString.substringFromIndex(advance(hexColorString.startIndex, 1))
        }
        
        if count(hexColorString) != 6 {
            var error: NSError?
            NSException.raise("Hex Color String Error", format: "Error: Invalid hex color string. Please ensure hex color string has 6 elements", arguments: getVaList([error ?? "nil"]))
        }
        
        var hexColorRGBValue:UInt32 = 0
        NSScanner(string: hexColorString).scanHexInt(&hexColorRGBValue)
        
        return self.changeHexColorCodeToRGB(hexColorRGBValue, alpha: 1)
    }
    
    
    //MARK: Private helper methods
    private
    func changeHexColorCodeToRGB(hex:UInt32, alpha: CGFloat) -> UIColor {
        
        return UIColor(   red: CGFloat((hex & 0xFF0000) >> 16)/255.0,
            green: CGFloat((hex & 0xFF00) >> 8)/255.0,
            blue: CGFloat((hex & 0xFF))/255.0,
            alpha: alpha)
    }

}