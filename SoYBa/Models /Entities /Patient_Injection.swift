//
//  Patient_Injection.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation
import CoreData
@objc(Patient_Injection)
class Patient_Injection: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var inject_day: NSDate
    @NSManaged var isDone: NSNumber
    @NSManaged var last_updated: NSDate
    @NSManaged var month: NSNumber
    @NSManaged var note: String
    @NSManaged var number: NSNumber
    @NSManaged var patientID: NSNumber
    @NSManaged var sickID: NSNumber
    @NSManaged var vacName: String

}
