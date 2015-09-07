//
//  Clinic.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation
import CoreData
@objc(Clinic)
class Clinic: NSManagedObject {

    @NSManaged var address: String
    @NSManaged var phone: String
    @NSManaged var id: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var state: String

}
