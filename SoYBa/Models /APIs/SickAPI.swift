//
//  SickAPI.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class SickAPI: NSObject {
    
    
    class func createSickUser(patientID: Int, sick: [Int]!, isUpdate: Bool, completion:()-> Void, failure:(error: String) ->Void) {
        
        var params:Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params["patient_id"] = patientID
        params["sicks"] = sick
        
        var urlStr = ""
        if isUpdate {
            urlStr = AppConstant.API.KEYs.Sick_UpdateSickUser
        } else {
            urlStr = AppConstant.API.KEYs.Sick_CreateSickUser
        }
        
        ModelManager.shareManager.postRequest(urlStr, params: params, success: { (responseData) -> Void in
            print(responseData)
            completion()
            }) { (errorMessage) -> Void in
                failure(error: errorMessage)
        }
    }
}
