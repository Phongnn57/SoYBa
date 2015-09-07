//
//  Sick_Vac.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation
import CoreData
@objc(Sick_Vac)
class Sick_Vac: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var sickID: NSNumber
    @NSManaged var vaccine: String

}
