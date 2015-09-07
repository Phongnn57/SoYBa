//
//  Patient_Sick.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation
import CoreData
@objc(Patient_Sick)
class Patient_Sick: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var patientID: NSNumber
    @NSManaged var sickID: NSNumber

}
