//
//  Patient.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation
import CoreData
@objc(Patient)
class Patient: NSManagedObject {

    @NSManaged var bloodType: String
    @NSManaged var dob: NSDate
    @NSManaged var gender: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var lastUpdated: NSDate
    @NSManaged var name: String
    @NSManaged var photo: String
    @NSManaged var relationshipWithUser: String
    @NSManaged var userID: NSNumber

}
