//
//  Sick.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import Foundation
import CoreData
@objc(Sick)
class Sick: NSManagedObject {

    @NSManaged var count: NSNumber
    @NSManaged var descrip: String
    @NSManaged var gender: NSNumber
    @NSManaged var id: NSNumber
    @NSManaged var sickCode: String
    @NSManaged var sickName: String

}
