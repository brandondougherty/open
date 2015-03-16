//
//  MapAnnotation.swift
//  Grubber
//
//  Created by brandon dougherty on 1/12/15.
//  Copyright (c) 2015 brandon dougherty. All rights reserved.
//

import Foundation
import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
    }
}