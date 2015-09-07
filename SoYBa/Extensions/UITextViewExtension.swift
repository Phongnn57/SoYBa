//
//  UITextViiewExtension.swift
//  Enbac
//
//  Created by Ngo Ngoc Chien on 7/1/15.
//  Copyright © 2015 Hoang Duy Nam. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return self.textContainer.lineFragmentPadding
        }
        set (padding) {
            self.textContainer.lineFragmentPadding = padding
        }
    }
}
