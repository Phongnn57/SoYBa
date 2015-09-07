//
//  UserObject.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit
import Foundation

class UserObject: NSObject, NSCoding {
    static var sharedUser: UserObject = UserObject()
    
    var name: String = ""
    var email: String = ""
    var fbAccessToken: String = ""
    var facebookID: String = ""
    var gender: Int = 0
    var googleID: String = ""
    var lastUpdated: Int = 0
    var photoURL: String = ""
    var userID: Int = 0
    
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        if let senderName = aDecoder.decodeObjectForKey("name") as? String {
            self.name = senderName
        }
        if let senderEmail = aDecoder.decodeObjectForKey("email") as? String {
            self.email = senderEmail
        }
        if let fbAccessToken = aDecoder.decodeObjectForKey("fbAccessToken") as? String {
            self.fbAccessToken = fbAccessToken
        }
        if let facebookID = aDecoder.decodeObjectForKey("facebookID") as? String {
            self.facebookID = facebookID
        }
        if let googleID = aDecoder.decodeObjectForKey("googleID") as? String {
            self.googleID = googleID
        }
        if let photoURL = aDecoder.decodeObjectForKey("photoURL") as? String {
            self.photoURL = photoURL
        }
        
        self.gender = aDecoder.decodeIntegerForKey("gender")
        self.userID = aDecoder.decodeIntegerForKey("userID")
        self.lastUpdated = aDecoder.decodeIntegerForKey("lastUpdated")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.fbAccessToken, forKey: "fbAccessToken")
        aCoder.encodeObject(self.facebookID, forKey: "facebookID")
        aCoder.encodeObject(self.googleID, forKey: "googleID")
        aCoder.encodeObject(self.photoURL, forKey: "photoURL")
        aCoder.encodeInteger(self.gender, forKey: "gender")
        aCoder.encodeInteger(self.userID, forKey: "userID")
        aCoder.encodeInteger(self.lastUpdated, forKey: "lastUpdated")
    }
    
    func saveOffline() {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserObject.fileLocation())
    }
    
    class func readOffline() {
        if let data: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(UserObject.fileLocation()){
            UserObject.sharedUser = (data as? UserObject) ?? UserObject()
        }
    }
    
    private class func fileLocation() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as! String
        return documentDirectory.stringByAppendingPathComponent(AppConstant.UserDefault.UserObject)
    }
}