//
//  Injection_Schedule.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation
import CoreData
@objc(Injection_Schedule)
class Injection_Schedule: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var month: NSNumber
    @NSManaged var number: NSNumber
    @NSManaged var sick: NSNumber

}
