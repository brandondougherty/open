//
//  SearchCategory.swift
//  Grubber
//
//  Created by brandon dougherty on 11/3/14.
//  Copyright (c) 2014 brandon dougherty. All rights reserved.
//

import Foundation

struct Location {
    let placeId: String
    let types : NSArray
    let name : String
    let rating : Double
    let vicinity: String
    let priceLevel : Int
    let open_now : Int
    let icon : String
    let lat: Double
    let long: Double
    var howMuchLonger: Int
    var hours : String
    var nextHours : String
    var yestHour : String
    var pin : Marker
    var phone : String
    var distance : String
}