//
//  SettingViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 9/1/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var hourLB: UILabel!
    @IBOutlet weak var dayBeforeLabel: UILabel!
    
    var switchNotify : SevenSwitch!
    
    var dayBefore: Int = 1
    var hour: Int = 8
    var patientInjection: [Patient_Injection]!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNavigationBarWithTitle("Cài đặt hệ thống")
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem()
        self.initialize()
        self.initializeData()
        self.patientInjection = Patient_Injection.MR_findAll() as! [Patient_Injection]
//        self.calculateTimeToReminder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func initialize() {
        self.switchNotify = SevenSwitch()
        self.switchNotify.frame = CGRectMake(SCREEN_SIZE.width - 80, 48, 70, 30)
        self.switchNotify.onLabel.text = "Bật"
        self.switchNotify.offLabel.text = "Tắt"
        self.switchNotify.activeColor = UIColor(rgba: "#328efe")
        self.switchNotify.onTintColor =  UIColor(red: 50/255, green: 142/255, blue: 254/255, alpha: 1)
        self.switchNotify.inactiveColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1)
        self.switchNotify.offLabel.textColor = UIColor.blackColor()
        self.switchNotify.onLabel.textColor = UIColor.blackColor()
        self.switchNotify.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.switchNotify)
        
        if USER_DEFAULT.boolForKey(AppConstant.UserDefault.Alarm_Enable) == true {
            self.switchNotify.on = true
        } else {
            self.switchNotify.on = false
        }
    }
    
    // MARK: CONFIG DATA
    func initializeData() {
        if USER_DEFAULT.integerForKey(AppConstant.UserDefault.Alarm_Day) != 0 {
            self.dayBefore = USER_DEFAULT.integerForKey(AppConstant.UserDefault.Alarm_Day)
            if self.dayBefore == 1 || self.dayBefore == 3 || self.dayBefore == 7 {
                self.dayBeforeLabel.text = "Trước \(self.dayBefore) ngày"
            } else {
                self.dayBefore = 1
                self.dayBeforeLabel.text = "Trước 1 ngày"
            }
        } else {
            self.dayBefore = 1
            self.dayBeforeLabel.text = "Trước 1 ngày"
        }
        if USER_DEFAULT.integerForKey(AppConstant.UserDefault.Alarm_Hour) != 0 {
            self.hour = USER_DEFAULT.integerForKey(AppConstant.UserDefault.Alarm_Hour)
            if self.hour == 8 {
                self.hourLB.text = "8 giờ sáng"
            } else if self.hour == 16 {
                self.hourLB.text = "16 giờ chiều"
            } else if self.hour == 20 {
                self.hourLB.text = "20 giờ tối"
            } else {
                self.hour = 8
                self.hourLB.text = "8 giờ sáng"
            }
        } else {
            self.hour = 8
            self.hourLB.text = "8 giờ sáng"
        }
    }
    
    func calculateTimeToReminder() {
        for obj in self.patientInjection {
            self.scheduleNotificationForDate(obj.inject_day.addDays(self.dayBefore).addHours(self.hour))
        }
    }
    
    func scheduleNotificationForDate(date: NSDate) {
        var localNotification = UILocalNotification()
        localNotification.fireDate = date
        
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.alertBody = "Sắp tới lịch tiêm chủng, hãy kiểm tra"
        
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = -1
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    // MARK: BUTTON 
    
    func switchChanged(sender: SevenSwitch) {
        if sender.on {
            USER_DEFAULT.setBool(true, forKey: AppConstant.UserDefault.Alarm_Enable)
            self.setAlarm()
        } else {
            USER_DEFAULT.setBool(false, forKey: AppConstant.UserDefault.Alarm_Enable)
            self.removeAllAlarm()
        }
    }
    
    func setAlarm() {
        self.removeAllAlarm()
        self.calculateTimeToReminder()
    }
    
    func removeAllAlarm() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    @IBAction func didSelectTimeToReminder(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Chọn giờ nhắc trong ngày", delegate: self, cancelButtonTitle: "Đóng", destructiveButtonTitle: nil, otherButtonTitles: "8 giờ sáng", "16 giờ chiều", "20 giờ tối")
        actionSheet.tag = 1
        actionSheet.showInView(self.view)
    }
    
    @IBAction func didSelectDayToReminder(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Chọn ngày nhắc", delegate: self, cancelButtonTitle: "Đóng", destructiveButtonTitle: nil, otherButtonTitles: "Trước 1 ngày", "Trước 3 ngày", "Trước 1 tuần")
        actionSheet.tag = 2
        actionSheet.showInView(self.view)
    }
    
    // MARK: ACTIONSHEET
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.tag == 1 {
            if buttonIndex == 1 {
                self.hourLB.text = "8 giờ sáng"
                self.hour = 8
            } else if buttonIndex == 2 {
                self.hourLB.text = "16 giờ chiều"
                self.hour = 16
            } else if buttonIndex == 3 {
                self.hourLB.text = "20 giờ tối"
                self.hour = 20
            }
            
            if buttonIndex != 0 {
                USER_DEFAULT.setInteger(self.hour, forKey: AppConstant.UserDefault.Alarm_Hour)
            }
        } else if actionSheet.tag == 2 {
            if buttonIndex == 1 {
                self.dayBeforeLabel.text = "Trước 1 ngày"
                self.dayBefore = 1
            } else if buttonIndex == 2 {
                self.dayBeforeLabel.text = "Trước 3 ngày"
                self.dayBefore = 3
            } else if buttonIndex == 3 {
                self.dayBeforeLabel.text = "Trước 1 tuần"
                self.dayBefore = 7
            }
            
            if buttonIndex != 0 {
                USER_DEFAULT.setInteger(self.dayBefore, forKey: AppConstant.UserDefault.Alarm_Day)
            }
        }
        
        self.setAlarm()
    }
    

}
