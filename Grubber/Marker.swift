//
//  Marker.swift
//  Grubber
//
//  Created by brandon dougherty on 1/7/15.
//  Copyright (c) 2015 brandon dougherty. All rights reserved.
//

import Foundation
import MapKit
class Marker: NSObject {
    var id:String
    var marker:MKAnnotation
    init(id: String,marker: MapPin) {
        self.id = id
        self.marker = marker
    }
}
