//
//  TopScrollView.swift
//  Enbac
//
//  Created by Hoang Duy Nam on 6/24/15.
//  Copyright (c) 2015 Hoang Duy Nam. All rights reserved.
//

import UIKit

class TopScrollView: UIScrollView {
    var buttonList = [UIButton]()
    var underLineView:UIView!
    
    var onMenuChange : ((index : Int)->())!
    var currentSelected : Int = 0
    override func awakeFromNib() {
        configScrollView()
    }
    
    
    func configScrollView(){
        underLineView = UIView()
        underLineView.tag = -999
        underLineView.frame = CGRectMake(0, self.frame.size.height - 1.5, SCREEN_SIZE.width/3, 1.5)
        underLineView.backgroundColor = UIColor(rgba: "#328efe")
        self.addSubview(underLineView)
        var buttonTitles = ["TỔNG QUAN", "CHI TIẾT", "LỊCH TIÊM"]
        var currentX:CGFloat = 0
        buttonList.removeAll()
        
        for var i = 0; i<buttonTitles.count; ++i{
            let button = UIButton()
            if("Thêm" == buttonTitles[i]){
                button.setTitle("", forState: UIControlState.Normal)
                button.setImage(UIImage(named: "_--0"), forState: UIControlState.Normal)
            }
            else{
                button.setTitle(buttonTitles[i], forState: UIControlState.Normal)
            }
            
            button.setTitleColor(UIColor(rgba: "#888888"), forState: UIControlState.Normal)
            button.setTitleColor(UIColor(rgba: "#328efe"), forState: UIControlState.Selected)
            button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
            button.tag = i
            button.addTarget(self, action: "topButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//            button.sizeToFit()
            button.frame = CGRectMake(CGFloat(SCREEN_SIZE.width/3) * CGFloat(i), 0, SCREEN_SIZE.width/3, self.frame.size.height)
            self.addSubview(button)
            buttonList.append(button)
        }
        self.contentSize = CGSizeMake(SCREEN_SIZE.width, self.frame.size.height)
    }
    
    func configScrollViewWithButtonTitleArraySelectedIndex(buttonTitles: Array<String>, SelectedIndex : Int) {
        for view in self.subviews{
            if let btn : UIButton = view as? UIButton{
                btn.removeFromSuperview()
            }
        }
        if let view : UIView = self.viewWithTag(-999)
        {
            view.removeFromSuperview()
        }
        let buttonSpace:CGFloat = 27
        underLineView = UIView()
        underLineView.tag = -999
        underLineView.frame = CGRectMake(buttonSpace/2, self.frame.size.height - 1.5, 40, 1.5)
        underLineView.backgroundColor = UIColor(rgba: "#328efe")
        self.addSubview(underLineView)
        
        var currentX:CGFloat = buttonSpace/2
        var buttonMove : UIButton = UIButton()
        for var i = 0; i<buttonTitles.count; ++i{
            let button = UIButton()
            if("Thêm" == buttonTitles[i]){
                button.setTitle("", forState: UIControlState.Normal)
                button.setImage(UIImage(named: "_--0"), forState: UIControlState.Normal)
            }
            else{
                button.setTitle(buttonTitles[i], forState: UIControlState.Normal)
            }
            button.setTitleColor(UIColor(rgba: "#888888"), forState: UIControlState.Normal)
            button.setTitleColor(UIColor(rgba: "#328efe"), forState: UIControlState.Selected)
            button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
            button.tag = i
            button.addTarget(self, action: "topButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            button.sizeToFit()
            button.frame = CGRectMake(currentX, 0, button.frame.size.width, self.frame.size.height)
            button.selected = i == SelectedIndex
            self.addSubview(button)
            buttonList.append(button)
            currentX += button.frame.size.width + buttonSpace //Tính x cho vị trí sau.
            
            if i == SelectedIndex {
                buttonMove = button
            }
            
        }
        self.contentSize = CGSizeMake(currentX - buttonSpace/2, self.frame.size.height)
        self.slideToButton(buttonMove, animated: true)

    }

    func topButtonPressed(sender:UIButton){
        for var index=0; index<buttonList.count; ++index{
            let button = buttonList[index]
            button.selected = false
        }
        sender.selected = true
        self.slideToButton(sender, animated: true)
        
        if(self.onMenuChange != nil){
            self.onMenuChange(index: sender.tag)
        }
    }
    
    func selectItemAtIndex(index: Int, animated: Bool){
        for var i=0; i<buttonList.count; ++i{
            let button = buttonList[i]
            button.selected = false
        }
        
        if(index >= 0 && index < self.buttonList.count){
            self.buttonList[index].selected = true
            
            self.slideToButton(self.buttonList[index], animated: animated)
        }
    }
    
    func slideToButton(button: UIButton, animated: Bool){
        currentSelected = button.tag
        var tempRect = underLineView.frame
        tempRect.origin.x = button.frame.origin.x
        tempRect.size.width = button.frame.size.width
        
        var point = button.convertPoint(CGPointMake(0, 0), toView: self)
        point.x -= self.contentOffset.x
        var newX: CGFloat = self.contentOffset.x
        
        newX = button.frame.origin.x - self.frame.width/2.0 + button.frame.width/2.0
        newX = max(newX, 0)
        newX = min(newX, self.contentSize.width - self.frame.width)
        
        if newX != self.contentOffset.x {
            if animated {
                self.setContentOffset(CGPointMake(newX, 0), animated: true)
                UIView.animateWithDuration(0.25, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.underLineView.frame = tempRect
                    }, completion: nil)
            }else {
                self.setContentOffset(CGPointMake(newX, 0), animated: false)
                self.underLineView.frame = tempRect
            }
        }else{
            if animated {
                UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.underLineView.frame = tempRect
                    }, completion: nil)
            }else {
                self.underLineView.frame = tempRect
            }
        }
    }
    
    func moveUnderLine(offsetX: CGFloat, index: Int) {
        if(index >= 0 && index < self.buttonList.count){
            var tempRect = underLineView.frame
            tempRect.origin.x = self.buttonList[index].frame.origin.x + (offsetX * (self.buttonList[index].frame.size.width / SCREEN_SIZE.width))
            tempRect.size.width = self.buttonList[index].frame.size.width
            self.underLineView.frame = tempRect
        }
    }
    
}
