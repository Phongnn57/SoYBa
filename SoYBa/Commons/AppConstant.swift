//
//  AppConstant.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation
import UIKit

let DELEGATE: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let SCREEN_SIZE: CGSize = UIScreen.mainScreen().bounds.size
let DEVICE_VERSION = (UIDevice.currentDevice().systemVersion as NSString).floatValue
let SCARE_SCREEN: CGFloat = SCREEN_SIZE.width / 375.0
let NOTIFICATION_CENTER: NSNotificationCenter = NSNotificationCenter.defaultCenter()
let USER_DEFAULT: NSUserDefaults = NSUserDefaults.standardUserDefaults()

// GOOGLE
let kClientId = "298954613553-dtv16j6lkrif6tvfbf7het3pl364g18j.apps.googleusercontent.com"


struct AppConstant {
    struct Fonts {
        
    }
    
    struct Notifications {
        
    }
    
    struct LoginType {
        static let Login_Facebook: String = "facebook_id"
        static let Login_Google: String = "google_id"
        static let Login_UserID: String = "user_id"
    }
    
    struct APIType {
        static let Create: String = "create"
        static let Update: String = "update"
    }
    
    struct UserDefault {
        static let UserObject: String = "UserObject"
        static let Login_With_Social: String = "LoginWithSocial"
        static let User_Avatar: String = "UserAvatar"
        static let Facebook_Friend_Next_Link: String = "FBFriendNextLink"
        
        static let Alarm_Hour: String = "alarm_hour"
        static let Alarm_Day: String = "alarm_day"
        static let Alarm_Enable: String = "alarm_enable"
    }
    
    struct API {
        struct URLs {
            static let BaseURL: String = "http://app.bluebee-uet.com/soyba/"
            
        }
        
        struct KEYs {
            static let User_API: String = "user/getuser"
            static let User_CreateUser: String = "user/createuser"
            
            static let Patient_CreatePatient: String = "patient/createpatientuser"
            static let Patient_GetSickPatient: String = "patient/getsickpatient"
            static let Patient_GetPatientInjection: String = "patient/getpatientinjection"
            static let Patient_GetPatientUser: String = "patient/getpatientuser"
            static let Patient_UpdatePatient: String = "patient/updatepatient"
            static let Patient_UpdateInjectionSchedule: String = "patient/updateis"
            static let Patient_GetWeightHeigh: String = "patient/getHeightWeight"
            static let Patient_DeletePatient: String = "patient/deleteapatient"
            
            static let Sick_CreateSickUser: String = "sick/createsickuser"
            static let Sick_UpdateSickUser: String = "sick/updatesickpatient"
            
            static let Pharmacy_GetPharmacy: String = "pharmacy/getPharmacy"
            
            static let Super_API: String = "super/superapiIOS"
        }
    }
    
    struct Entities {
        static let Pharmacy: Int = 0
        static let Sick: Int = 1
        static let InjectionSchedule: Int = 2
    }
}

let BloodType: [String] = ["O-", "O+", "A-", "A+", "B-", "B+", "AB-", "AB+"]

//
let TermStr = "Các nội dung trên ứng dụng này được sử dụng cho mục đích tham khảo, gợi ý. Bạn không được bỏ qua lời khuyên tiêm chủng từ bác sĩ nhi khoa của con bạn hoặc chậm trễ trong việc tiêm chủng vì bất kỳ thông tin nào mà bạn đã đọc trên ứng dụng này.\nỨng dụng này cung cấp thông tin vắc-xin cho mục đích tham khảo. Tác giả không đảm bảo ứng dụng này là một nguồn thông tin toàn diện về vấn đề tiêm chủng.\nMục đích của ứng dụng này không phải dùng để cung cấp khuyến cáo y tế về tiêm chủng. Bạn phải luôn luôn tham khảo ý kiến bác sĩ nhi khoa của con mình trước khi đưa ra quyết định liên quan đến việc tiêm chủng cho con.\nBạn không nên sử dụng thông tin này để tự lên lịch trình tiêm chủng cho con mình. Luôn luôn sử dụng lịch trình tiêm chủng mà bác sĩ nhi khoa của con bạn đề nghị và sử dụng ứng dụng này như một sự trợ giúp trong việc nhắc nhở tiêm chủng cho con bạn.\nTác giả của ứng dụng này có quyền thêm, thay đổi thông tin, ngừng tạm thời hoặc vĩnh viễn ứng dụng này (hoặc bất kỳ phần nào) mà không cần thông báo trước cho người dùng.\nTrong mọi trường hợp tác giả của ứng dụng này không phải chịu trách nhiệm trong bất kỳ thiệt hại trực tiếp, hoặc gián tiếp từ việc sử dụng của bạn, hoặc bất kỳ lỗi hay thiếu sót trong thông tin trên ứng dụng này gây ra"
