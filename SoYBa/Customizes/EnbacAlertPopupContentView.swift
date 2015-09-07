//
//  EnbacAlertPopupContentView.swift
//  Enbac
//
//  Created by Ngo Ngoc Chien on 7/3/15.
//  Copyright © 2015 Hoang Duy Nam. All rights reserved.
//

import UIKit

@objc protocol EnbacAlertPopupDelegate {
    optional func alertPopupDidSelectCancelButton(alertView: UIView, extraTag: Int)
    optional func alertPopupDidSelectDoneButton(alertView: UIView, extraTag: Int)
}

// Thông tin mũi tiêm
class InjectionContentView: UIView {
    var titleStr: String?
    
    var injectionCount: Int!
    var injectionName: String?
    var injectionDay: String?
    var injectionStatus: String?
    var injectionNote: String?
    
    var cancelButtonTitle: String!
    var doneButtonTitle: String!
    
    var delegate: EnbacAlertPopupDelegate?
    
    private let contentMarginHoz = (left: CGFloat(10.0), right: CGFloat(10.0))
    private let itemMarginTop: CGFloat = 12
    private let buttonHeight: CGFloat = 40.0
    private let titleFont = UIFont.systemFontOfSize(17)
    private let messageFont = UIFont.systemFontOfSize(14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, injectionCount: Int, injectionName: String?,injectionDay: String?, injectionStatus: String?, note: String?, cancelButtonTitle: String?, doneButtonTitle: String?) {
        let popupWidth = min(315.0, SCREEN_SIZE.width - 20.0)
        super.init(frame: CGRectMake(0, 0, popupWidth, 0))
        
        self.titleStr = title
        self.injectionCount = injectionCount
        self.injectionName = injectionName
        self.injectionStatus = injectionStatus
        self.injectionDay = injectionDay
        self.injectionNote = note
        self.cancelButtonTitle = cancelButtonTitle
        self.doneButtonTitle = doneButtonTitle
        
        
        self.frame = CGRectMake(0, 0, frame.width, self.calculatePopupHeight(popupWidth))
        self.setupInterface(popupWidth)
    }
    
    private func calculatePopupHeight(popupWidth: CGFloat) -> CGFloat {
        var popupHeight = self.itemMarginTop
        let contentWidth = popupWidth - self.contentMarginHoz.left - self.contentMarginHoz.right
        
        
        
        if let _titleStr = self.titleStr where !_titleStr.isEmpty {
            popupHeight += (Utilities.measureTextHeight(_titleStr, font: self.titleFont, maxWidth: contentWidth) + self.itemMarginTop)
        }
        
        popupHeight += (42 + self.itemMarginTop)
        
        if let _injectionName = self.injectionName where !_injectionName.isEmpty{
            popupHeight += (Utilities.measureTextHeight(_injectionName, font: self.messageFont, maxWidth: contentWidth) + self.itemMarginTop)
        } else {
            popupHeight += (21 + self.itemMarginTop)
        }
        
        if let _injectionDay = self.injectionDay where !_injectionDay.isEmpty{
            popupHeight += (Utilities.measureTextHeight(_injectionDay, font: self.messageFont, maxWidth: contentWidth) + self.itemMarginTop)
        } else {
            popupHeight += (21 + self.itemMarginTop)
        }
        
        if let _injectionStatus = self.injectionStatus where !_injectionStatus.isEmpty{
            popupHeight += (Utilities.measureTextHeight(_injectionStatus, font: self.messageFont, maxWidth: contentWidth) + self.itemMarginTop)
        } else {
            popupHeight += (21 + self.itemMarginTop)
        }
        
        if let _injectionNote = self.injectionNote where !_injectionNote.isEmpty{
            popupHeight += (Utilities.measureTextHeight("Ghi chú: ".stringByAppendingString(_injectionNote) , font: self.messageFont, maxWidth: contentWidth) + self.itemMarginTop)
        } else {
            popupHeight += (21 + self.itemMarginTop)
        }
        
        if((self.cancelButtonTitle != nil && !self.cancelButtonTitle!.isEmpty) || self.doneButtonTitle != nil && !self.doneButtonTitle!.isEmpty) {
            popupHeight += self.buttonHeight
        }
        
        return popupHeight
    }
    
    private func setupInterface(popupWidth: CGFloat) {
        let contentWidth = popupWidth - self.contentMarginHoz.left - self.contentMarginHoz.right
        var marginTop = self.itemMarginTop
        
        if let _titleStr = self.titleStr where !_titleStr.isEmpty {
            let textHeight = (Utilities.measureTextHeight(_titleStr, font: self.titleFont, maxWidth: contentWidth))
            let lbTitle = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, textHeight))
            lbTitle.numberOfLines = 0
            lbTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lbTitle.textAlignment = NSTextAlignment.Center
            lbTitle.textColor = UIColor(rgba: "#444444")
            lbTitle.font = self.titleFont
            lbTitle.backgroundColor = UIColor.clearColor()
            lbTitle.text = _titleStr
            self.addSubview(lbTitle)
            
            marginTop += (textHeight + self.itemMarginTop)
        }

        // line seperator
        let separator = UIView(frame: CGRectMake(0, marginTop, popupWidth, 0.5))
        separator.backgroundColor = UIColor(rgba: "#e5e5e5")
        separator.clipsToBounds = true
        self.addSubview(separator)
        
        marginTop += self.itemMarginTop
        
        // inection name
        let lbInjectName = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, 21))
        lbInjectName.textColor = UIColor(rgba: "#666666")
        lbInjectName.font = self.messageFont
        lbInjectName.textAlignment = NSTextAlignment.Left
        lbInjectName.backgroundColor = UIColor.clearColor()
        lbInjectName.text = "Tên bệnh: " + self.injectionName!
        self.addSubview(lbInjectName)
        
        marginTop += (21 + self.itemMarginTop)
        
        //injection count
        let lbInjectCount = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, 21))
        lbInjectCount.textColor = UIColor(rgba: "#666666")
        lbInjectCount.font = self.messageFont
        lbInjectCount.textAlignment = NSTextAlignment.Left
        lbInjectCount.backgroundColor = UIColor.clearColor()
        lbInjectCount.text = "Mũi tiêm: \(self.injectionCount)"
        self.addSubview(lbInjectCount)
        
        marginTop += (21 + self.itemMarginTop)
        
        
        // injection day
        let lbInjectDay = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, 21))
        lbInjectDay.textColor = UIColor(rgba: "#666666")
        lbInjectDay.font = self.messageFont
        lbInjectDay.textAlignment = NSTextAlignment.Left
        lbInjectDay.backgroundColor = UIColor.clearColor()
        lbInjectDay.text = "Ngày tiêm: " + self.injectionDay!
        self.addSubview(lbInjectDay)
        
        marginTop += (21 + self.itemMarginTop)
        
        // status
        let lbInjectStatus = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, 21))
        lbInjectStatus.textColor = UIColor(rgba: "#666666")
        lbInjectStatus.font = self.messageFont
        lbInjectStatus.textAlignment = NSTextAlignment.Left
        lbInjectStatus.backgroundColor = UIColor.clearColor()
        lbInjectStatus.text = "Trạng thái: " + self.injectionStatus!
        self.addSubview(lbInjectStatus)
        
        marginTop += (21 + self.itemMarginTop)
        
        // note
        

        if let _injectionNote = self.injectionNote where !_injectionNote.isEmpty {
            let textHeight = (Utilities.measureTextHeight( "Ghi chú: ".stringByAppendingString(_injectionNote) , font: self.messageFont, maxWidth: contentWidth))
            let lbNote = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, textHeight))
            lbNote.numberOfLines = 0
            lbNote.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lbNote.textAlignment = NSTextAlignment.Justified
            lbNote.textColor = UIColor(rgba: "#666666")
            lbNote.font = self.messageFont
            lbNote.backgroundColor = UIColor.clearColor()
            lbNote.text = "Ghi chú: ".stringByAppendingString(_injectionNote)
            self.addSubview(lbNote)
            
            marginTop += (textHeight + self.itemMarginTop)
        } else {
            let lbInjectNote = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, 21))
            lbInjectNote.textColor = UIColor(rgba: "#666666")
            lbInjectNote.font = self.messageFont
            lbInjectNote.textAlignment = NSTextAlignment.Left
            lbInjectNote.backgroundColor = UIColor.clearColor()
            lbInjectNote.text = "Ghi chú: " + self.injectionNote!
            self.addSubview(lbInjectNote)
            
            marginTop += (21 + self.itemMarginTop)
        }
        
        var constaintButton = false
        var cancelButton: UIButton?
        if let _buttonTitle = self.cancelButtonTitle where !_buttonTitle.isEmpty {
            cancelButton = UIButton.buttonWithType(.Custom) as? UIButton
            cancelButton!.backgroundColor = UIColor.clearColor()
            cancelButton!.setTitle(_buttonTitle, forState: UIControlState.Normal)
            cancelButton!.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(cancelButton!)
            constaintButton = true
        }
        
        var doneButton: UIButton?
        if let _buttonTitle = self.doneButtonTitle where !_buttonTitle.isEmpty {
            doneButton = UIButton.buttonWithType(.Custom) as? UIButton
            doneButton!.backgroundColor = UIColor.clearColor()
            doneButton!.setTitle(_buttonTitle, forState: UIControlState.Normal)
            doneButton!.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(doneButton!)
            constaintButton = true
        }
        
        // separator
        if(constaintButton) {
            let separator = UIView(frame: CGRectMake(0, marginTop, popupWidth, 0.5))
            separator.backgroundColor = UIColor(rgba: "#e5e5e5")
            separator.clipsToBounds = true
            self.addSubview(separator)
        }
        
        if let _cancelButton = cancelButton, let _doneButton = doneButton {
            _cancelButton.frame = CGRectMake(0, marginTop, popupWidth/2.0, self.buttonHeight)
            _cancelButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _cancelButton.setTitleColor(UIColor(rgba: "#666666"), forState: UIControlState.Normal)
            _cancelButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            
            _doneButton.frame = CGRectMake(popupWidth/2.0, marginTop, popupWidth/2.0, self.buttonHeight)
            _doneButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _doneButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _doneButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }else if let _cancelButton = cancelButton {
            _cancelButton.frame = CGRectMake(0, marginTop, popupWidth, self.buttonHeight)
            _cancelButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _cancelButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _cancelButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }else if let _doneButton = doneButton {
            _doneButton.frame = CGRectMake(0, marginTop, popupWidth, self.buttonHeight)
            _doneButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _doneButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _doneButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }
    }
    
    func cancel() {
        delegate?.alertPopupDidSelectCancelButton?(self, extraTag: 0)
    }
    
    func done() {
        delegate?.alertPopupDidSelectDoneButton?(self, extraTag: 0)
    }
}

class EnbacAlertPopupContentView: UIView {

    var titleStr: String?
    var messageStr: String?
    var cancelButtonTitle: String!
    var doneButtonTitle: String!
    var delegate: EnbacAlertPopupDelegate?
    
    private let contentMarginHoz = (left: CGFloat(10.0), right: CGFloat(10.0))
    private let itemMarginTop: CGFloat = 12
    private let buttonHeight: CGFloat = 40.0
    private let titleFont = UIFont.systemFontOfSize(17)
    private let messageFont = UIFont.systemFontOfSize(14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, message: String?, cancelButtonTitle: String?, doneButtonTitle: String?) {
        let popupWidth = min(315.0, SCREEN_SIZE.width - 20.0)
        super.init(frame: CGRectMake(0, 0, popupWidth, 0))
        
        self.titleStr = title
        self.messageStr = message
        self.cancelButtonTitle = cancelButtonTitle
        self.doneButtonTitle = doneButtonTitle
        
        self.frame = CGRectMake(0, 0, frame.width, self.calculatePopupHeight(popupWidth))
        self.setupInterface(popupWidth)
    }
    
    init(title: String?, longText: String?, cancelButtonTitle: String?, doneButtonTitle: String?) {
        let popupWidth = min(315.0, SCREEN_SIZE.width - 20.0)
        super.init(frame: CGRectMake(0, 0, popupWidth, 0))
        
        self.titleStr = title
        self.messageStr = longText
        self.cancelButtonTitle = cancelButtonTitle
        self.doneButtonTitle = doneButtonTitle
        
        self.frame = CGRectMake(0, 0, frame.width, self.calculatePopupHeight(popupWidth))
        self.setupView(popupWidth)
    }
    
    private func calculatePopupHeight(popupWidth: CGFloat) -> CGFloat {
        var popupHeight = self.itemMarginTop * 2
        let contentWidth = popupWidth - self.contentMarginHoz.left - self.contentMarginHoz.right
        
        if let _titleStr = self.titleStr where !_titleStr.isEmpty {
            popupHeight += (Utilities.measureTextHeight(_titleStr, font: self.titleFont, maxWidth: contentWidth) + self.itemMarginTop)
        }
        
        if let _messageStr = self.messageStr where !_messageStr.isEmpty {
            popupHeight += (Utilities.measureTextHeight(_messageStr, font: self.messageFont, maxWidth: contentWidth) + self.itemMarginTop)
        }
        
        if((self.cancelButtonTitle != nil && !self.cancelButtonTitle!.isEmpty) || self.doneButtonTitle != nil && !self.doneButtonTitle!.isEmpty) {
            popupHeight += self.buttonHeight
        }
        
        if popupHeight > SCREEN_SIZE.height - 80 {
            popupHeight = SCREEN_SIZE.height - 80
        }
        
        return popupHeight
    }
    
    private func setupView(popupWidth: CGFloat) {
        let contentWidth = popupWidth - self.contentMarginHoz.left - self.contentMarginHoz.right
        var marginTop = self.itemMarginTop
        
        if let _titleStr = self.titleStr where !_titleStr.isEmpty {
            let textHeight = (Utilities.measureTextHeight(_titleStr, font: self.titleFont, maxWidth: contentWidth))
            let lbTitle = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, textHeight))
            lbTitle.numberOfLines = 0
            lbTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lbTitle.textAlignment = NSTextAlignment.Center
            lbTitle.textColor = UIColor(rgba: "#444444")
            lbTitle.font = self.titleFont
            lbTitle.backgroundColor = UIColor.clearColor()
            lbTitle.text = _titleStr
            self.addSubview(lbTitle)
            
            marginTop += (textHeight + self.itemMarginTop)
        }
        
        let separator = UIView(frame: CGRectMake(0, marginTop, popupWidth, 0.5))
        separator.backgroundColor = UIColor(rgba: "#e5e5e5")
        separator.clipsToBounds = true
        self.addSubview(separator)
        
        
        
        if let _messageStr = self.messageStr where !_messageStr.isEmpty {
            let textHeight = (Utilities.measureTextHeight(_messageStr, font: self.messageFont, maxWidth: contentWidth))
            
            if textHeight + marginTop + self.itemMarginTop + self.buttonHeight >= SCREEN_SIZE.height - 80 {
                let textView = UITextView(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, SCREEN_SIZE.height - 80 - (marginTop + self.itemMarginTop + self.buttonHeight)))
                textView.textColor = UIColor(rgba: "#666666")
                textView.font = self.messageFont
                textView.backgroundColor = UIColor.clearColor()
                textView.textAlignment = NSTextAlignment.Justified
                textView.text = _messageStr
                self.addSubview(textView)
                
                marginTop += textView.frame.height
            } else {
                marginTop += (self.itemMarginTop)
                
                let lbMessage = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, textHeight))
                lbMessage.numberOfLines = 0
                lbMessage.lineBreakMode = NSLineBreakMode.ByWordWrapping
                lbMessage.textAlignment = NSTextAlignment.Center
                lbMessage.textColor = UIColor(rgba: "#666666")
                lbMessage.font = self.messageFont
                lbMessage.backgroundColor = UIColor.clearColor()
                lbMessage.text = _messageStr
                self.addSubview(lbMessage)
                
                marginTop += (textHeight + self.itemMarginTop)
            }
        }
        
        var constaintButton = false
        var cancelButton: UIButton?
        if let _buttonTitle = self.cancelButtonTitle where !_buttonTitle.isEmpty {
            cancelButton = UIButton.buttonWithType(.Custom) as? UIButton
            cancelButton!.backgroundColor = UIColor.clearColor()
            cancelButton!.setTitle(_buttonTitle, forState: UIControlState.Normal)
            cancelButton!.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(cancelButton!)
            constaintButton = true
        }
        
        var doneButton: UIButton?
        if let _buttonTitle = self.doneButtonTitle where !_buttonTitle.isEmpty {
            doneButton = UIButton.buttonWithType(.Custom) as? UIButton
            doneButton!.backgroundColor = UIColor.clearColor()
            doneButton!.setTitle(_buttonTitle, forState: UIControlState.Normal)
            doneButton!.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(doneButton!)
            constaintButton = true
        }
        
        // separator
        if(constaintButton) {
            let separator = UIView(frame: CGRectMake(0, marginTop, popupWidth, 0.5))
            separator.backgroundColor = UIColor(rgba: "#e5e5e5")
            separator.clipsToBounds = true
            self.addSubview(separator)
            marginTop += (self.itemMarginTop/2)
        }
        
        if let _cancelButton = cancelButton, let _doneButton = doneButton {
            _cancelButton.frame = CGRectMake(0, marginTop, popupWidth/2.0, self.buttonHeight)
            _cancelButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _cancelButton.setTitleColor(UIColor(rgba: "#666666"), forState: UIControlState.Normal)
            _cancelButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            
            _doneButton.frame = CGRectMake(popupWidth/2.0, marginTop, popupWidth/2.0, self.buttonHeight)
            _doneButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _doneButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _doneButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }else if let _cancelButton = cancelButton {
            _cancelButton.frame = CGRectMake(0, marginTop, popupWidth, self.buttonHeight)
            _cancelButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _cancelButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _cancelButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }else if let _doneButton = doneButton {
            _doneButton.frame = CGRectMake(0, marginTop, popupWidth, self.buttonHeight)
            _doneButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _doneButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _doneButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }

    }
    
    private func setupInterface(popupWidth: CGFloat) {
        let contentWidth = popupWidth - self.contentMarginHoz.left - self.contentMarginHoz.right
        var marginTop = self.itemMarginTop
        
        if let _titleStr = self.titleStr where !_titleStr.isEmpty {
            let textHeight = (Utilities.measureTextHeight(_titleStr, font: self.titleFont, maxWidth: contentWidth))
            let lbTitle = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, textHeight))
            lbTitle.numberOfLines = 0
            lbTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lbTitle.textAlignment = NSTextAlignment.Center
            lbTitle.textColor = UIColor(rgba: "#444444")
            lbTitle.font = self.titleFont
            lbTitle.backgroundColor = UIColor.clearColor()
            lbTitle.text = _titleStr
            self.addSubview(lbTitle)
            
            marginTop += (textHeight + self.itemMarginTop)
        }
        
        let separator = UIView(frame: CGRectMake(0, marginTop, popupWidth, 0.5))
        separator.backgroundColor = UIColor(rgba: "#e5e5e5")
        separator.clipsToBounds = true
        self.addSubview(separator)
        
        marginTop += (self.itemMarginTop)
        
        if let _messageStr = self.messageStr where !_messageStr.isEmpty {
            let textHeight = (Utilities.measureTextHeight(_messageStr, font: self.messageFont, maxWidth: contentWidth))
            let lbMessage = UILabel(frame: CGRectMake(self.contentMarginHoz.left, marginTop, contentWidth, textHeight))
            lbMessage.numberOfLines = 0
            lbMessage.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lbMessage.textAlignment = NSTextAlignment.Center
            lbMessage.textColor = UIColor(rgba: "#666666")
            lbMessage.font = self.messageFont
            lbMessage.backgroundColor = UIColor.clearColor()
            lbMessage.text = _messageStr
            self.addSubview(lbMessage)
            
            marginTop += (textHeight + self.itemMarginTop)
        }
        
        var constaintButton = false
        var cancelButton: UIButton?
        if let _buttonTitle = self.cancelButtonTitle where !_buttonTitle.isEmpty {
            cancelButton = UIButton.buttonWithType(.Custom) as? UIButton
            cancelButton!.backgroundColor = UIColor.clearColor()
            cancelButton!.setTitle(_buttonTitle, forState: UIControlState.Normal)
            cancelButton!.addTarget(self, action: "cancel", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(cancelButton!)
            constaintButton = true
        }
        
        var doneButton: UIButton?
        if let _buttonTitle = self.doneButtonTitle where !_buttonTitle.isEmpty {
            doneButton = UIButton.buttonWithType(.Custom) as? UIButton
            doneButton!.backgroundColor = UIColor.clearColor()
            doneButton!.setTitle(_buttonTitle, forState: UIControlState.Normal)
            doneButton!.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(doneButton!)
            constaintButton = true
        }
        
        // separator
        if(constaintButton) {
            let separator = UIView(frame: CGRectMake(0, marginTop, popupWidth, 0.5))
            separator.backgroundColor = UIColor(rgba: "#e5e5e5")
            separator.clipsToBounds = true
            self.addSubview(separator)
        }
        
        if let _cancelButton = cancelButton, let _doneButton = doneButton {
            _cancelButton.frame = CGRectMake(0, marginTop, popupWidth/2.0, self.buttonHeight)
            _cancelButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _cancelButton.setTitleColor(UIColor(rgba: "#666666"), forState: UIControlState.Normal)
            _cancelButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            
            _doneButton.frame = CGRectMake(popupWidth/2.0, marginTop, popupWidth/2.0, self.buttonHeight)
            _doneButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _doneButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _doneButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }else if let _cancelButton = cancelButton {
            _cancelButton.frame = CGRectMake(0, marginTop, popupWidth, self.buttonHeight)
            _cancelButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _cancelButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _cancelButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }else if let _doneButton = doneButton {
            _doneButton.frame = CGRectMake(0, marginTop, popupWidth, self.buttonHeight)
            _doneButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            _doneButton.setTitleColor(UIColor(rgba: "#2961ad"), forState: UIControlState.Normal)
            _doneButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
        }
    }
    
    func cancel() {
        delegate?.alertPopupDidSelectCancelButton?(self, extraTag: 0)
    }
    
    func done() {
        delegate?.alertPopupDidSelectDoneButton?(self, extraTag: 0)
    }

}
