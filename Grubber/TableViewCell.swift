//
//  TableViewCell.swift
//  Grubber
//
//  Created by brandon dougherty on 11/5/14.
//  Copyright (c) 2014 brandon dougherty. All rights reserved.
//

import UIKit
import MapKit

class TableViewCell: UITableViewCell {
    var phoneNumber : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var name : String = ""
    // @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var vicinity: UILabel!
    @IBOutlet weak var listNumber: UILabel!
    @IBOutlet weak var hours: UILabel!
    
    @IBOutlet weak var numberIconBackground: UIImageView!
    
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var locIcon: UIImageView!
    @IBOutlet weak var stitch1: UIImageView!
    @IBOutlet weak var stitch2: UIImageView!
    @IBOutlet weak var stitch3: UIImageView!
    @IBOutlet weak var stictchfirst: UIImageView!
    @IBOutlet weak var phoneText: UIButton!
    @IBOutlet weak var distance: UILabel!
    @IBAction func getDirections(sender: AnyObject) {
        
        let regionDistance:CLLocationDistance = 10000
        var coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(self.name)"
        mapItem.openInMapsWithLaunchOptions(options)
    }
    @IBAction func callPlace(sender: AnyObject) {
        let rootViewController: UIViewController! = UIApplication.sharedApplication().windows[0].rootViewController!
        let alertController = UIAlertController(
            title: "Call",
            message: "Do you want to call \(locationName.text!)? ",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Call", style: .Default) { (action) in
            var regex : NSRegularExpression = NSRegularExpression(pattern: "\\D", options:NSRegularExpressionOptions.CaseInsensitive, error: nil)!
            var newString : String = regex.stringByReplacingMatchesInString(self.phoneNumber, options: nil, range: NSMakeRange(0, self.phoneNumber.utf16Count), withTemplate: "")
            
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + newString)!)
        }
        alertController.addAction(openAction)
        
        rootViewController.presentViewController(alertController, animated: true, completion: nil)
       
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadItem(#name: String, open: Int, location: String,timeLeft:Int,hoursToday:String, nextHours: String, yestHour: String,phone: String, lat: Double, long:Double,dist:String) {
        locationName.text = name
        vicinity.text = location
        hours.text = hoursToday
        let image1 = UIImage(named: "green")
        numberIconBackground.image = UIImage(named: "numberIcon")
        phoneIcon.image = UIImage(named: "phoneIcon")
        clockIcon.image = UIImage(named: "clockicon")
        locIcon.image = UIImage(named: "locIcon")
        stitch1.image = UIImage(named: "stitch")
        stitch2.image = UIImage(named: "stitch")
        stitch3.image = UIImage(named: "stitch")
        stictchfirst.image = UIImage(named: "stitch")
        phoneText.setTitle(phone, forState: .Normal)
        self.phoneNumber = phone
        self.latitude = lat
        self.longitude = long
        self.name = name
            
        distance.text = dist
    }
}