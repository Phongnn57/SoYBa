//
//  ModelManager.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class ModelManager: NSObject {
    static let shareManager = ModelManager(baseURL: AppConstant.API.URLs.BaseURL)
    
    var mainManager:AFHTTPRequestOperationManager!
    
    init(baseURL:String) {
        super.init()
        
        mainManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: baseURL))
        mainManager.requestSerializer = AFJSONRequestSerializer()
        mainManager.responseSerializer = AFJSONResponseSerializer(readingOptions: NSJSONReadingOptions.AllowFragments)
        mainManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        mainManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mainManager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html", "application/json") as Set<NSObject>
    }
    
    func getRequest(path:String!, params: Dictionary<String, AnyObject>, success:(responseData:AnyObject) -> Void, failure:(errorMessage:String) -> Void) {
        mainManager.GET(path, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            success(responseData: responseObject)
            
            
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print(error.description)
                if(error.code == 3840){
                    failure(errorMessage: "Lỗi 3840. Vui lòng gọi tổng đài để được hỗ trợ.")
                }else{
                    failure(errorMessage: "Không thể kết nối đến máy chủ, vui lòng kiểm tra lại đường truyền mạng!")
                }
        }
    }
    
    
    func postRequest(path:String!, params: Dictionary<String, AnyObject>, success:(responseData:AnyObject) -> Void, failure:(errorMessage:String) -> Void){
        
        var mparams = params
        
        var formParams: Dictionary<String, NSData> = Dictionary<String, NSData>()
        for key in mparams.keys.array {
            if let dataAny: AnyObject = mparams[key]{
                var data: NSData?
                if(dataAny is String || dataAny is NSString){
                    data = String(dataAny as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
                }else if(dataAny is NSNumber){
                    let _dataAny = dataAny as! NSNumber
                    data = String(_dataAny.stringValue).dataUsingEncoding(NSUTF8StringEncoding)
                }else if(dataAny is Int){
                    data = String("\((dataAny as! Int))").dataUsingEncoding(NSUTF8StringEncoding)
                }else if(dataAny is CGFloat){
                    data = String("\((dataAny as! CGFloat))").dataUsingEncoding(NSUTF8StringEncoding)
                }else if(dataAny is Double){
                    data = String("\((dataAny as! Double))").dataUsingEncoding(NSUTF8StringEncoding)
                }else {
                    data = NSJSONSerialization.dataWithJSONObject(dataAny, options: nil, error: nil)
                }
                
                formParams[key] = data
            }
        }
        
        //Start the request
        mainManager.POST(path, parameters: nil, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
            for key in formParams.keys.array{
                if let data = formParams[key as String]{
                    formData.appendPartWithFormData(data, name: key)
                }
            }
            }, success: {  (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                if(responseObject == nil || !(responseObject is Dictionary<String, AnyObject>)){
                    failure(errorMessage: "Lỗi không xác định, vui lòng gọi tổng đài để được hỗ trợ.")
                    return
                }
                
                let responseData: Dictionary = responseObject as! Dictionary<String, AnyObject>
                println(responseData)
                var message = ""
                if(responseData["message"] != nil){
                    message = responseData["message"] as! String
                }
                
                if(responseData["status"] != nil && ((responseData["status"] as? Int) == 1 || (responseData["status"] as? String) == "1")){
                    let contentData: AnyObject? = responseData["data"]
                    success(responseData: contentData!)
                    return
                }
                
                message = message.isEmpty ? "Lỗi không xác định, vui lòng gọi tổng đài để được hỗ trợ." : message
                failure(errorMessage: message)
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print(error.description)
                if(error.code == 3840){
                    failure(errorMessage: "Lỗi 3840. Vui lòng gọi tổng đài để được hỗ trợ.")
                }else{
                    failure(errorMessage: "Không thể kết nối đến máy chủ, vui lòng kiểm tra lại đường truyền mạng!")
                }
                
        }
    }
    
}