//
//  EnbacAlertPopup.swift
//  Enbac
//
//  Created by Ngo Ngoc Chien on 7/3/15.
//  Copyright © 2015 Hoang Duy Nam. All rights reserved.
//

import UIKit

class EnbacAlertPopup: CustomPopupView, EnbacAlertPopupDelegate {
    
    var extraTag: Int?
    var delegate: EnbacAlertPopupDelegate?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String?, message: String?, cancelButtonTitle: String?, doneButtonTitle: String?) {
        let _contentView = EnbacAlertPopupContentView(title: title, message: message, cancelButtonTitle: cancelButtonTitle, doneButtonTitle: doneButtonTitle)
        super.init(inputView: _contentView)
        _contentView.delegate = self
        _contentView.layer.cornerRadius = 8.0
        _contentView.backgroundColor = UIColor(rgba: "#FFFFFF")
    }
    
    init(title: String?, longText: String?, cancelButtonTitle: String?, doneButtonTitle: String?) {
        let _contentView = EnbacAlertPopupContentView(title: title, longText: longText, cancelButtonTitle: cancelButtonTitle, doneButtonTitle: doneButtonTitle)
        super.init(inputView: _contentView)
        _contentView.delegate = self
        _contentView.layer.cornerRadius = 8.0
        _contentView.backgroundColor = UIColor(rgba: "#FFFFFF")
    }

    init(title: String?, injectionCount: Int, injectionName: String?,injectionDay: String?, injectionStatus: String?, note: String?, cancelButtonTitle: String?, doneButtonTitle: String?) {
        let _contentView = InjectionContentView(title: title, injectionCount: injectionCount, injectionName: injectionName, injectionDay: injectionDay, injectionStatus: injectionStatus, note: note, cancelButtonTitle: cancelButtonTitle, doneButtonTitle: doneButtonTitle)
        super.init(inputView: _contentView)
        _contentView.delegate = self
        _contentView.layer.cornerRadius = 8.0
        _contentView.backgroundColor = UIColor(rgba: "#FFFFFF")
    }
    
    override func openPopup() {
        super.openPopup()
    }
    
    func alertPopupDidSelectCancelButton(alertView: UIView, extraTag: Int) {
        self.dismissPopup()
        self.delegate?.alertPopupDidSelectCancelButton?(self, extraTag: self.extraTag ?? 0)
    }
    
    func alertPopupDidSelectDoneButton(alertView: UIView, extraTag: Int) {
        self.dismissPopup()
        self.delegate?.alertPopupDidSelectDoneButton?(self, extraTag: self.extraTag ?? 0)
    }
    
}
