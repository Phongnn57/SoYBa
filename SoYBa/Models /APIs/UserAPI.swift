//
//  UserAPI.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class UserAPI: NSObject {
    
    class func callSuperAPI(userID: Int, completion:()-> Void, failure:(error: String) ->Void) {
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["user_id"] = userID
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Super_API, params: params, success: { (responseData) -> Void in
            print(responseData)
            if let data: Dictionary<String, AnyObject> = responseData as? Dictionary<String, AnyObject> {
                if let patientData: Array<AnyObject> = data["patient_data"] as? Array<AnyObject> {
                    print(patientData)
                    for patient in patientData {
                        let _patient = Patient.MR_createEntity() as! Patient
                        _patient.bloodType = patient["bloodType"] as? String ?? ""
                        _patient.dob = (patient["dob"] as! String).toDate()!
                        _patient.gender = Utilities.numberFromJSONAnyObject(patient["gender"]) ?? 0
                        _patient.id = Utilities.numberFromJSONAnyObject(patient["patient_id"]) ?? 0
                        _patient.lastUpdated = NSDate(timeIntervalSince1970: Utilities.numberFromJSONAnyObject(patient["last_updated"])!.doubleValue)
                        _patient.name = patient["name"] as? String ?? ""
                        _patient.relationshipWithUser = patient["relationshipWithUser"] as? String ?? ""
                        _patient.userID = Utilities.numberFromJSONAnyObject(patient["user_id"]) ?? 0
                        
                        NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                    }
                }
                
                if let sickData: Array<AnyObject> = data["sick_data"] as? Array<AnyObject> {
                    print(sickData)
                    for sick in sickData {
                        if let _senderSick: Array<AnyObject> = sick as? Array<AnyObject> {
                            
                            for senderSick in _senderSick {
                                let _sick = Patient_Sick.MR_createEntity() as! Patient_Sick
                                _sick.id = Utilities.numberFromJSONAnyObject(senderSick["id"]) ?? 0
                                _sick.sickID = Utilities.numberFromJSONAnyObject(senderSick["sick_id"]) ?? 0
                                _sick.patientID = Utilities.numberFromJSONAnyObject(senderSick["patient_id"]) ?? 0
                                
                                NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                            }
                        }
                    }
                }
                
                if let injectData: Array<AnyObject> = data["inject_data"] as? Array<AnyObject> {
                    print(injectData)
                    for inject  in injectData {
                        if let _senderInject: Array<AnyObject> = inject as? Array<AnyObject> {
                            for senderInject in _senderInject {
                                let _inject = Patient_Injection.MR_createEntity() as! Patient_Injection
                                _inject.isDone = Utilities.numberFromJSONAnyObject(senderInject["done"]) ?? 0
                                _inject.id = Utilities.numberFromJSONAnyObject(senderInject["id"]) ?? 0
                                _inject.inject_day = (senderInject["inject_day"] as! String).toDate()!
                                _inject.last_updated = NSDate(timeIntervalSince1970: Utilities.numberFromJSONAnyObject(senderInject["last_updated"])!.doubleValue)
                                _inject.month = Utilities.numberFromJSONAnyObject(senderInject["month"]) ?? 0
                                _inject.number = Utilities.numberFromJSONAnyObject(senderInject["number"]) ?? 0
                                _inject.patientID = Utilities.numberFromJSONAnyObject(senderInject["patient_id"]) ?? 0
                                _inject.sickID = Utilities.numberFromJSONAnyObject(senderInject["sick_id"]) ?? 0
                                _inject.vacName = senderInject["vaccine_name"] as? String ?? ""
                                _inject.note = senderInject["note"] as? String ?? ""
                                
                                NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                            }
                        }
                    }
                }
                
                completion()
            }
            
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    // MARK:
    class func getUserWithLoginType(loginType: String, loginID: String, completion:(existUser: Bool)-> Void, failure:(error: String) ->Void) {
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params[loginType] = loginID
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.User_API, params: params, success: { (responseData) -> Void in
            
            if let userData: Dictionary<String, AnyObject> = responseData as? Dictionary<String, AnyObject> {
                var usr = UserObject()
                
                usr.name = userData["name"] as! String
                usr.email = userData["email"] as! String
                usr.facebookID = userData["facebook_id"] as! String
                usr.fbAccessToken = userData["facebook_access_token"] as! String
                usr.googleID = userData["google_id"] as! String
                usr.photoURL = userData["photo"] as! String
                
                usr.gender = (Utilities.numberFromJSONAnyObject(userData["gender"])!.integerValue)
                
                usr.lastUpdated = (Utilities.numberFromJSONAnyObject(userData["last_updated"])!.integerValue)
                usr.userID = (Utilities.numberFromJSONAnyObject(userData["user_id"])!.integerValue)
                
                usr.saveOffline()
                UserObject.sharedUser = usr
                completion(existUser: true)
            } else {
                completion(existUser: false)
            }
            
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func createUser(loginType: String, loginID: String, gender: Int, accessToken: String!, photoURL: String!, name: String!, email: String, completion:()-> Void, failure:(error: String) ->Void) {
        
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params[loginType] = loginID
        params["gender"] = gender
        params["facebook_access_token"] = accessToken
        params["photo"] = photoURL
        params["name"] = name
        params["email"] = email
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.User_CreateUser, params: params, success: { (responseData) -> Void in
            print(responseData)
            
            var usr = UserObject()
            
            usr.name = name
            usr.email = email
            if loginType == AppConstant.LoginType.Login_Facebook {
                usr.facebookID = loginID
            } else if loginType == AppConstant.LoginType.Login_Google {
                usr.googleID = loginID
            } else {
                usr.userID = Utilities.numberFromJSONAnyObject(loginID)!.integerValue
            }
            usr.userID = Utilities.numberFromJSONAnyObject(responseData)!.integerValue
            usr.fbAccessToken = accessToken
            usr.photoURL = photoURL
            usr.gender = gender
            
            usr.saveOffline()
            UserObject.sharedUser = usr
            
            completion()
            
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
}