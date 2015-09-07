//
//  SkyDanceAnnotation.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/31/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit
import MapKit

class SkyDanceAnnotation: NSObject ,MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subTitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subTitle = subtitle
        super.init()
    }

}
