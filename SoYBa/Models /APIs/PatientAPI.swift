//
//  PatientAPI.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class PatientAPI: NSObject {
    
    class func createPatientUser(name: String, dob: String, gender: Int, userID: Int, relationShip: String, bloodType: String, completion:(patientID: NSNumber)-> Void, failure:(error: String) ->Void) {
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["name"] = name
        params["dob"] = dob
        params["gender"] = gender
        params["user_id"] = userID
        params["relationshipWithUser"] = relationShip
        params["bloodType"] = bloodType
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Patient_CreatePatient, params: params, success: { (responseData) -> Void in
            println(responseData)
            if let patientID: NSNumber = Utilities.numberFromJSONAnyObject(responseData) {
                completion(patientID: patientID)
            }
            
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func updatePatientUser(patientID: Int, name: String, relationShip: String, bloodType: String, lastUpdated: Int, completion:()-> Void, failure:(error: String) ->Void) {
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["patient_id"] = patientID
        params["patient_name"] = name
        params["relationshipWithUser"] = relationShip
        params["bloodType"] = bloodType
        params["last_updated"] = lastUpdated
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Patient_UpdatePatient, params: params, success: { (responseData) -> Void in
            print(responseData)
            completion()
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func updatePatientInjectionSchedule(patientID: Int, sickID: Int, number: Int, injectDay: String, isDone: Int, vacName  : String, note: String,  lastUpdated: Int, completion:()-> Void, failure:(error: String) ->Void) {
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["patient_id"] = patientID
        params["sick_id"] = sickID
        params["number"] = number
        params["inject_day"] = injectDay
        params["is_done"] = isDone
        params["vac_name"] = vacName
        params["note"] = note
        params["last_updated"] = lastUpdated
        
//        patient_id, sick_id, number, inject_day, is_done, vac_name, note, last_updated
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Patient_UpdateInjectionSchedule, params: params, success: { (responseData) -> Void in
            print(responseData)
            completion()
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func getSickPatient(patientID: Int, completion:()-> Void, failure:(error: String) ->Void) {
        
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["patient_id"] = patientID
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Patient_GetSickPatient, params: params, success: { (responseData) -> Void in
            print(responseData)
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    
    // MARK: TO BE ADDED
    class func getWeighHeight(patientID: Int, completion:()-> Void, failure:(error: String) ->Void) {
        
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["patient_id"] = patientID
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Patient_GetSickPatient, params: params, success: { (responseData) -> Void in
            print(responseData)
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func getPatientInjection(patientID: Int, completion:()-> Void, failure:(error: String) ->Void) {
        
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["patient_id"] = patientID
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Patient_GetPatientInjection, params: params, success: { (responseData) -> Void in
            print(responseData)
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func getPatientUser(userID: Int, completion:()-> Void, failure:(error: String) ->Void) {
        
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["user_id"] = userID
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Patient_GetPatientUser, params: params, success: { (responseData) -> Void in
            print(responseData)
            
            if let patientData: Array<AnyObject> = responseData["patient_data"] as? Array<AnyObject> {
                for _patient in patientData {
                    if let patient:Dictionary<String, AnyObject> = _patient as? Dictionary<String, AnyObject> {
                        let senderPatient = Patient.MR_createEntity() as! Patient
                        senderPatient.bloodType = patient["bloodType"] as! String
                        senderPatient.dob = (patient["dob"] as! String).toDate(format: "dd-MM-yyyy")!
                        senderPatient.gender = Utilities.numberFromJSONAnyObject(patient["gender"])!
                        senderPatient.id = Utilities.numberFromJSONAnyObject(patient["patient_id"])!
                        senderPatient.name = patient["name"] as! String
                        senderPatient.relationshipWithUser = patient["relationshipWithUser"] as! String
                        senderPatient.userID = Utilities.numberFromJSONAnyObject(patient["user_id"])!
                        
                        NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                    }
                }
            }
            
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
    
    class func deleteAPatient(patientID: Int, completion:()-> Void, failure:(error: String) ->Void) {
        
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["patient_id"] = patientID
        
        ModelManager.shareManager.postRequest(AppConstant.API.KEYs.Patient_DeletePatient, params: params, success: { (responseData) -> Void in
            print(responseData)
            completion()
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
}
