//
//  ClinicAPI.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/31/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class ClinicAPI: NSObject {
    class func getClinic(number: Int, offset: Int, completion:(clinics: [Clinic]!)-> Void, failure:(error: String) ->Void) {
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["number"] = number
        params["offset"] = offset
        
        ModelManager.shareManager.getRequest(AppConstant.API.KEYs.Pharmacy_GetPharmacy, params: params, success: { (responseData) -> Void in
            print(responseData)
            
            if let data: Array<AnyObject> = responseData["data"] as? Array<AnyObject> {
                var senderClinics: [Clinic] = [Clinic]()
                for clinic in data {
                    let senderClinic = Clinic.MR_createEntity() as! Clinic
                    
                    senderClinic.address = clinic["address"] as! String
                    senderClinic.phone = clinic["contact_num"] as! String
                    senderClinic.id = Utilities.numberFromJSONAnyObject(clinic["id"])!
                    senderClinic.latitude = Utilities.numberFromJSONAnyObject(clinic["laititude"])! ?? 0
                    senderClinic.longitude = Utilities.numberFromJSONAnyObject(clinic["longitude"])! ?? 0
                    senderClinic.name = clinic["name"] as? String ?? ""
                    senderClinic.state = clinic["state"] as? String ?? ""
                    
                    senderClinics.append(senderClinic)
                }
                completion(clinics: senderClinics)
            } else {
                completion(clinics: nil)
            }
            
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }

}
