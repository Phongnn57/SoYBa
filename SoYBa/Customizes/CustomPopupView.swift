//
//  CustomPopupView.swift
//  Enbac
//
//  Created by Hoang Duy Nam on 6/16/15.
//  Copyright (c) 2015 Hoang Duy Nam. All rights reserved.
//

import UIKit

class CustomPopupView: UIView {
    
    var contentView:UIView!
    
    init(inputView view:UIView!){
        super.init(frame: CGRectZero)
        
        
        let window = UIApplication.sharedApplication().delegate?.window
        
        if let temp = window??.bounds{
            self.frame = temp
        }
        contentView = view
        
        self.addSubview(view)
        
        view.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
    
        window??.addSubview(self)
        
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openPopup(){
        
        contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2)
        
        UIView.animateWithDuration(0.2/1.5, animations: { () -> Void in
                self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)
            }, completion: {
                finished in
                
                UIView.animateWithDuration(0.2/2, animations: { () -> Void in
                    self.contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)
                    }, completion: {
                        finished in
                        
                        UIView.animateWithDuration(0.2/2, animations: { () -> Void in
                            self.contentView.transform = CGAffineTransformIdentity
                            
                        })
                })
        })
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first
//        let point = touch?.locationInView(self.contentView)
//        if(point == nil || point!.x < 0 || point!.y < 0 || point!.x > self.contentView.frame.width || point!.y > self.contentView.frame.height){
//            //self.dismissPopup()
//        }
//    }
    
    func dismissPopup() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        self.removeFromSuperview()
    }
    
    func keyboardWillShow(){
        self.moveViewUp()
    }
    
    func keyboardWillHide(){
        self.moveViewDow()
    }
    
    func moveViewUp(){
        //for test only
        UIView.animateWithDuration(0.2/2, animations: { () -> Void in
            self.contentView.center = CGPointMake(self.contentView.center.x, self.frame.size.height/2 - 80) //Center of screen
        })
    }
    
    func moveViewDow(){
        UIView.animateWithDuration(0.2/2, animations: { () -> Void in
            self.contentView.center = CGPointMake(self.contentView.center.x, self.frame.size.height/2) //Center of screen
            
        })
    }
}
