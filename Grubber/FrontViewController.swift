//
//  FrontViewController.swift
//  Grubber
//
//  Created by brandon dougherty on 1/8/15.
//  Copyright (c) 2015 brandon dougherty. All rights reserved.
//

import Foundation
import UIKit

class FrontViewController: UIViewController,CLLocationManagerDelegate, UITextFieldDelegate{
    var button: UIButton!
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var myTextField: UITextField!
    var locationManager: CLLocationManager! = nil
   @IBOutlet var sliderDisplayLabel : UILabel!

    override func viewDidLoad() {
       initLocationManager();
        navigationController?.navigationBar.hidden = true
        navigationController?.view.backgroundColor = UIColor(red: 188.0/255.0, green: 222.0/255.0, blue: 165.0/255.0, alpha: 1)
        //LOGO
        let imageName = "mainlogo.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: self.view.frame.width/2 - 104, y: self.view.frame.height/3 - 120, width: 208, height: 104)
        view.addSubview(imageView)
        println(self.view.frame.width)
        //SLIDER
        var sliderDemo = UISlider(frame:CGRectMake(self.view.frame.width/2 - 95, self.view.frame.height/2 + 10 , 190, 100))
        sliderDemo.setThumbImage(UIImage(named: "sliderthumb"), forState: .Normal)
        let leftTrackImage = UIImage(named: "sliderImg")
        let rightTrackImage = UIImage(named: "sliderGrey")
        
        let sliderContainerImg = UIImage(named: "sliderContainer")
        var sliderContainer = UIImageView(frame: CGRect(x: self.view.frame.width/2 - 112, y: self.view.frame.height/2 + 40, width: 221, height: 49))
        sliderContainer.image = sliderContainerImg
        let myInsets : UIEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8)
        let trackLeftResizable = leftTrackImage!.resizableImageWithCapInsets(myInsets)
        let trackRightResizable = rightTrackImage!.resizableImageWithCapInsets(myInsets)
        
        sliderDemo.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
        sliderDemo.setMaximumTrackImage(trackRightResizable, forState: .Normal)
        sliderDemo.minimumValue = 0.5
        sliderDemo.maximumValue = 30
        sliderDemo.continuous = true
        sliderDemo.tintColor = UIColor.redColor()
        sliderDemo.value = 16
        Singleton.sharedInstance.sliderValue = 5 * 1609.34
        sliderDemo.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(sliderContainer)
        self.view.addSubview(sliderDemo)
        
        let sliderLabelImg = UIImage(named: "milesImg")
        var sliderLabel = UIImageView(frame: CGRect(x: self.view.frame.width/2 - 22.5, y: self.view.frame.height/2 - 21, width: 45, height: 45))
        sliderLabel.image = sliderLabelImg
        sliderDisplayLabel = UILabel(frame: CGRectMake(self.view.frame.width/2 - 25, self.view.frame.height/2 - 26, 50,50))
        sliderDisplayLabel.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2 + 1)
        sliderDisplayLabel.textAlignment = NSTextAlignment.Center
        self.sliderDisplayLabel.text = "5mi"
        self.sliderDisplayLabel.font = UIFont(name: "Arial-BoldItalicMT", size: 15)
        self.sliderDisplayLabel.textColor = UIColor(red: 144.0/255.0, green: 148.0/255.0, blue: 150.0/255.0, alpha: 1)
        self.view.addSubview(sliderLabel)
        self.view.addSubview(sliderDisplayLabel)
        
        //Box one
        let boxOneImg = UIImage(named: "boxOne")
        var boxOneView = UIImageView(frame: CGRect(x: self.view.frame.width/2 - 112, y: self.view.frame.height/2 - 80, width: 163, height: 49))
        boxOneView.image = boxOneImg
        
        //Box one location button
        let buttonImageNormalLoc = UIImage(named: "locationIcon") as UIImage?
        let buttonImageHoverLoc = UIImage(named: "locationIcon") as UIImage?
        let buttonLoc   = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonLoc.frame = CGRectMake(self.view.frame.width/2 + 67.5, self.view.frame.height/2 - 78, 45, 45)
        buttonLoc.setImage(buttonImageNormalLoc, forState: .Normal)
        buttonLoc.setImage(buttonImageHoverLoc,forState: .Highlighted)
        buttonLoc.addTarget(self, action: "zipcodeAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(buttonLoc)

        self.view.addSubview(boxOneView)
         myTextField = UITextField(frame: CGRect(x: self.view.frame.width/2 - 96, y: self.view.frame.height/2 - 78, width: 150, height: 40.00));
        myTextField.delegate = self
        myTextField.textColor = UIColor(red: 144.0/255.0, green: 148.0/255.0, blue: 150.0/255.0, alpha: 1)
        myTextField.placeholder = "Current Location"
        myTextField.userInteractionEnabled = false
        self.view.addSubview(myTextField)
        
        //Button Food
        let buttonImageNormal = UIImage(named: "buttonLeft") as UIImage?
        let buttonImageHover = UIImage(named: "buttonLeftHover") as UIImage?
        let button   = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(self.view.frame.width/2-110, self.view.frame.height/3 * 2 + 50, 96, 96)
        button.setImage(buttonImageNormal, forState: .Normal)
        button.setImage(buttonImageHover,forState: .Highlighted)
        button.addTarget(self, action: "foodAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        //Button Bar
        let button2ImageNormal = UIImage(named: "buttonRight") as UIImage?
        let button2ImageHover = UIImage(named: "buttonRightHover") as UIImage?
        let button2   = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button2.frame = CGRectMake(self.view.frame.width/2 + 20, self.view.frame.height/3 * 2 + 50, 96, 96)
        button2.setImage(button2ImageNormal, forState: .Normal)
        button2.setImage(button2ImageHover,forState: .Highlighted)
        button2.addTarget(self, action: "barAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button2)
        
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //myTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    func trackRectForBounds( bounds: CGRect) -> CGRect{
        return CGRect(x:self.view.frame.width/2 - 135, y:self.view.frame.height/2, width:self.view.frame.width, height:100)
    }
     func sliderValueDidChange(sender:UISlider!)
     {
            var val = 0.25 
        switch Int(sender.value) {
            case 0:
                val = 0.25
            case 1:
                val = 0.25
            case 2:
                val = 0.5
            case 3:
                val = 1
            case 4:
                val = 1.5
            case 5:
                val = 2
            case 6:
                val = 2.5
            case 7:
                 val = 3
            case 8:
                 val = 3.5
            case 9:
                 val = 4
            case 10:
                 val = 4.5
            case 11:
                 val = 5
            case 12:
                 val = 5
            case 13:
                 val = 5
            case 14:
                 val = 5
            case 15:
                 val = 5
            case 16:
                 val = 5
            case 17:
                 val = 10
            case 18:
                 val = 12
            case 19:
                 val = 14
            case 20:
                 val = 15
            case 21:
                 val = 16
            case 22:
                 val = 17
            case 23:
                 val = 18
            case 24:
                val = 19
            case 25:
                 val  = 20
            case 26:
                 val = 22
            case 27:
                 val = 24
            case 28:
                 val = 26
            case 29:
                 val = 28
            case 30:
                 val = 30
            default:
                 val = 1
        }
        println("value--\(val)")
        var feedbackString: String;
        if(val > 1){
          feedbackString = NSString(format:"%.0lfmi",val)
        }else{
          feedbackString = NSString(format: "%.2lfmi", val)
        }
        
        Singleton.sharedInstance.sliderValue = Float(val) * 1609.34
        self.sliderDisplayLabel.text = feedbackString
        
    }
    
 //location stuff
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    func foodAction(sender: UIButton!) {
        Singleton.sharedInstance.madeRequest = "food"
        
        if(Singleton.sharedInstance.zipcode){
            var address = self.myTextField.text
             Singleton.sharedInstance.madeRequestLoc = address
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error)->Void in
                if error == nil {
                    if let placemark = placemarks?[0] as? CLPlacemark {
                        Singleton.sharedInstance.lat = placemark.location.coordinate.latitude
                        Singleton.sharedInstance.long = placemark.location.coordinate.longitude
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        let vc = TableViewController() //change this to your class name
                        self.navigationController?.pushViewController(vc,animated:true)
                    }else{
                        //error couldnt find location
                        let alertController = UIAlertController(
                            title: "Error",
                            message: "Looks like Apple geocoder could not find that City or Zip Code. Check your spelling.",
                            preferredStyle: .Alert)
                        
                        let cancelAction = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }else{
                    //error couldnt find location
                    let alertController = UIAlertController(
                        title: "Error",
                        message: "Looks like Apple geocoder could not find that City or Zip Code. Check your spelling.",
                        preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            })
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = TableViewController() //change this to your class name
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }
    func barAction(sender: UIButton!) {
        Singleton.sharedInstance.madeRequest = "bar"
        if(Singleton.sharedInstance.zipcode){
        var address = self.myTextField.text
        Singleton.sharedInstance.madeRequestLoc = address
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error)->Void in
            if error == nil {
                if let placemark = placemarks?[0] as? CLPlacemark {
                    Singleton.sharedInstance.lat = placemark.location.coordinate.latitude
                    Singleton.sharedInstance.long = placemark.location.coordinate.longitude
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    let vc = TableViewController() //change this to your class name
                    self.navigationController?.pushViewController(vc,animated:true)
                }else{
                    //error couldnt find location
                    let alertController = UIAlertController(
                        title: "Ooops!",
                        message: "Looks like Apple geocoder could not find that City or Zip Code. Check your spelling.",
                        preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
                //error couldnt find location
                let alertController = UIAlertController(
                    title: "Error",
                    message: "Looks like Apple geocoder could not find that City or Zip Code. Check your spelling.",
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = TableViewController() //change this to your class name
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }
    func zipcodeAction(sender: UIButton!) {
        Singleton.sharedInstance.zipcode = true
        if(myTextField.userInteractionEnabled){
            myTextField.userInteractionEnabled = false
            let buttonImageNormal = UIImage(named: "locationIcon")
            sender.setImage(buttonImageNormal, forState: .Normal)
            sender.setImage(buttonImageNormal,forState: .Highlighted)
            self.myTextField.text = ""
            self.myTextField.placeholder = "Current Location"
            Singleton.sharedInstance.zipcode = false
        }else{
            myTextField.userInteractionEnabled = true
            let buttonImageNormal = UIImage(named: "locationIconZIP")
            sender.setImage(buttonImageNormal, forState: .Normal)
            sender.setImage(buttonImageNormal,forState: .Highlighted)
            self.myTextField.placeholder = "Zip Code/City"
            self.myTextField.becomeFirstResponder()
            Singleton.sharedInstance.zipcode = true
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            switch status {
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
                manager.requestWhenInUseAuthorization()
            case .AuthorizedWhenInUse, .Restricted, .Denied:
                let alertController = UIAlertController(
                    title: "Background Location Access Disabled",
                    message: "In order to be notified about delicious food near you, please open this app's settings and set location access to 'Allow'.",
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(openAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
            } else {
                //show zip code input field
                
                NSLog("Denied access: \(locationStatus)")
            }
    }


}