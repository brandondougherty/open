//
//  GlobalSingleton.swift
//  Grubber
//
//  Created by brandon dougherty on 1/9/15.
//  Copyright (c) 2015 brandon dougherty. All rights reserved.
//

import Foundation

class Singleton {
    class var sharedInstance: Singleton {
        struct Static {
            static var instance: Singleton?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Singleton()
        }
        
        return Static.instance!
    }
    var pageToken:String = ""
    var madeRequest:String = ""
    var previousRequest:String = ""
    var sliderValue:Float = 0.0
    var sliderRequestValue:Float = 0.0
    var locations = [Location]()
    var page : Int = 0;
    var maxPage : Int = 0;
    var cellExpansionArray = [Int](count: 250, repeatedValue: 0)
    var i : Int = 0;
    var zipcode : Bool = false
    var lat : Double = 0.0
    var long : Double = 0.0
    var madeRequestLoc : String = ""
    var prevMadeRequestLoc : String = ""
    var distSort : Bool = false
    var timeSort : Bool = false
    var scrollNumber : Int = 0
    var interstitial:GADInterstitial?
}