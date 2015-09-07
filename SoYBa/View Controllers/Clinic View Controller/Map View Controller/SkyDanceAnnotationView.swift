//
//  SkyDanceAnnotationView.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/31/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit
import MapKit

class SkyDanceAnnotationView: MKAnnotationView {
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.image = UIImage(named: "")
        self.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height)
        
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
