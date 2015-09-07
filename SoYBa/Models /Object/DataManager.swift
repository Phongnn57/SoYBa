//
//  DataManager.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    class func parseMedicalStation(contentsOfURL: NSURL, encoding: NSStringEncoding, error: NSErrorPointer, entity: Int) {
        let delimiter = ","
        if let content = String(contentsOfURL: contentsOfURL, encoding: encoding, error: error) {
            let lines:[String] = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.rangeOfString("\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:NSScanner = NSScanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substringToIndex(1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpToString("\"", intoString: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpToString(delimiter, intoString: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value as! String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < count(textScanner.string) {
                                textToScan = (textScanner.string as NSString).substringFromIndex(textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = NSScanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.componentsSeparatedByString(delimiter)
                    }
                    
                    if entity == AppConstant.Entities.Pharmacy {
                        var pharmarcy = Clinic.MR_createEntity() as! Clinic
                        pharmarcy.id = values[0].toInt()! ?? 0
                        pharmarcy.name = values[1]
                        pharmarcy.address = values[2]
                        pharmarcy.longitude = values[3].toFloat()! ?? 0
                        pharmarcy.latitude = values[4].toFloat()! ?? 0
                        pharmarcy.state = values[5]
                        pharmarcy.phone = values[6]
                    } else if entity == AppConstant.Entities.Sick {
                        var sick = Sick.createEntity() as! Sick
                        sick.id = values[0].toInt()! ?? 0
                        sick.sickName = values[1]
                        sick.descrip = values[2]
                        sick.gender = values[3].toInt()! ?? 0
                        sick.sickCode = values[4]
                        sick.count = values[5].toInt()! ?? 0
                        
                        NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                    } else if entity == AppConstant.Entities.InjectionSchedule {
                        var injectionSchedule = Injection_Schedule.createEntity() as! Injection_Schedule
                        
                        injectionSchedule.id = values[0].toInt()!
                        injectionSchedule.sick = values[1].toInt()!
                        injectionSchedule.month = values[2].toInt()!
                        injectionSchedule.number = values[3].toInt()!
                    }
                }
            }
        }
    }
    
    class func preloadData () {
        if let contentsOfURL = NSBundle.mainBundle().URLForResource("Clinic", withExtension: "csv") {
            var error:NSError?
            
            self.parseMedicalStation(contentsOfURL, encoding: NSUTF8StringEncoding, error: &error, entity: AppConstant.Entities.Pharmacy)
        }
        if let contentsOfURL = NSBundle.mainBundle().URLForResource("Sick", withExtension: "csv") {
            var error:NSError?
            
            self.parseMedicalStation(contentsOfURL, encoding: NSUTF8StringEncoding, error: &error, entity: AppConstant.Entities.Sick)
        }
        
        if let contentsOfURL = NSBundle.mainBundle().URLForResource("Injection_Schedule", withExtension: "csv") {
            var error:NSError?
            
            self.parseMedicalStation(contentsOfURL, encoding: NSUTF8StringEncoding, error: &error, entity: AppConstant.Entities.InjectionSchedule)
        }
    }
}
