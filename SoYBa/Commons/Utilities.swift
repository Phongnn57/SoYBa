//
//  Utilities.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation


class Utilities {
    class func numberFromJSONAnyObject(anyValue: AnyObject?) -> NSNumber?{
        if(anyValue == nil){
            return nil
        }
        
        if(anyValue is String){
            let intValue: NSNumber? = NSNumberFormatter().numberFromString((anyValue as! String))
            if(intValue != nil){
                return intValue!
            }
        }else if(anyValue is NSNumber){
            return anyValue as? NSNumber
        }
        
        return NSNumber(float: 0)
    }
    
    class func getIntString(anyValue: AnyObject?) -> String {
        var intString = (anyValue as? String) ?? ""
        if(intString.isEmpty){
            intString = "\(Utilities.numberFromJSONAnyObject(anyValue)?.integerValue ?? 0)"
        }
        
        return intString
    }
    
    class func formatNumber(number: Int) -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        return numberFormatter.stringFromNumber(number)!
    }
    
    class func measureTextSize(text: String, font: UIFont) -> CGSize {
        let attributes = [NSFontAttributeName : font]
        
        return text.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
    class func measureTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes = [NSFontAttributeName : font]
        
        return text.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size.width
    }
    
    class func measureTextHeight(text: String, font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let attributes = [NSFontAttributeName : font]
        
        return text.boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size.height
    }
    
    class func measureAttributedTextHeight(attrText: NSAttributedString, font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let attrString = NSMutableAttributedString(attributedString: attrText)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attrText.length))
        
        let boundingRect = attrString.boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        return boundingRect.size.height
    }
    
    class func isNilOrEmpty(object: AnyObject?) -> Bool {
        if(object == nil) {
            return true
        }
        if(object is String && (object as! String).isEmpty){
            return true
        }
        if(object is Array<AnyObject> && (object as! Array<AnyObject>).count == 0){
            return true
        }
        if(object is Dictionary<String, AnyObject> && (object as! Dictionary<String, AnyObject>).count == 0){
            return true
        }
        return false
    }
}