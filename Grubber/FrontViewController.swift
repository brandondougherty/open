//
//  FrontViewController.swift
//  Grubber
//
//  Created by brandon dougherty on 1/8/15.
//  Copyright (c) 2015 brandon dougherty. All rights reserved.
//

import Foundation
import UIKit

class FrontViewController: GAITrackedViewController,GADBannerViewDelegate, GADInterstitialDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    var button: UIButton!
     var coord : CLLocationCoordinate2D!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var myTextField: UITextField!
    var locationManager: CLLocationManager! = nil
    
   @IBOutlet var sliderDisplayLabel : UILabel!
    
    var loadRequestAllowed = true
    var bannerDisplayed = false
    let statusbarHeight:CGFloat = 20.0

    override func viewDidLoad() {
        self.screenName = "Front Page"
       initLocationManager();
        navigationController?.navigationBar.hidden = true
        navigationController?.view.backgroundColor = UIColor(red: 22.0/255.0, green: 196.0/255.0, blue: 89.0/255.0, alpha: 1)
        //LOGO
        let imageName = "mainlogo.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: self.view.frame.width/2 - 107, y: self.view.frame.height/3 - 130, width: 215, height: 100)
        view.addSubview(imageView)
        //slogan img
        let sloganimageName = "slogan"
        let sloganimage = UIImage(named: sloganimageName)
        let sloganimageView = UIImageView(image: sloganimage!)
        sloganimageView.frame = CGRect(x: self.view.frame.width/2 - 104, y: self.view.frame.height/3 - 20, width: 215, height: 15)
        view.addSubview(sloganimageView)
        //food text img
        let foodTextimageName = "foodText"
        let foodTextimage = UIImage(named: foodTextimageName)
        let foodTextimageView = UIImageView(image: foodTextimage!)
        foodTextimageView.frame = CGRect(x: self.view.frame.width/2-100, y: self.view.frame.height - 40, width: 60, height: 15)
        view.addSubview(foodTextimageView)
        //drinks text img
        let drinkTextimageName = "drinkText"
        let drinkTextimage = UIImage(named: drinkTextimageName)
        let drinkTextimageView = UIImageView(image: drinkTextimage!)
        drinkTextimageView.frame = CGRect(x: self.view.frame.width/2 + 19, y: self.view.frame.height - 40, width: 93, height: 15)
        view.addSubview(drinkTextimageView)
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
        let buttonLoc   = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
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
        let button   = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = CGRectMake(self.view.frame.width/2-115, self.view.frame.height - 145, 96, 96)
        button.setImage(buttonImageNormal, forState: .Normal)
        button.setImage(buttonImageHover,forState: .Highlighted)
        button.addTarget(self, action: "foodAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        //Button Bar
        let button2ImageNormal = UIImage(named: "buttonRight") as UIImage?
        let button2ImageHover = UIImage(named: "buttonRightHover") as UIImage?
        let button2   = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button2.frame = CGRectMake(self.view.frame.width/2 + 15, self.view.frame.height - 145, 96, 96)
        button2.setImage(button2ImageNormal, forState: .Normal)
        button2.setImage(button2ImageHover,forState: .Highlighted)
        button2.addTarget(self, action: "barAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button2)
        
        //add help view
        //add checkbox to select hide perm
        //close button
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Singleton.sharedInstance.interstitial = nil
        Singleton.sharedInstance.interstitial = createAndLoadInterstitial()
    }
    //Interstitial func
    func createAndLoadInterstitial()->GADInterstitial {
        println("createAndLoadInterstitial")
        Singleton.sharedInstance.interstitial = GADInterstitial()
        Singleton.sharedInstance.interstitial!.delegate = self
        Singleton.sharedInstance.interstitial!.adUnitID = "ca-app-pub-1449159202125999/8102937464"
        
        var requestAd = GADRequest()
        if(coord != nil){
            requestAd.setLocationWithLatitude(CGFloat(Singleton.sharedInstance.lat), longitude: CGFloat(Singleton.sharedInstance.long), accuracy: 10000)
        }
        // requestAd.testDevices = [ GAD_SIMULATOR_ID ];
        Singleton.sharedInstance.interstitial!.loadRequest(requestAd)
        
        return Singleton.sharedInstance.interstitial!
    }
    
    func presentInterstitial() {
        if let isReady = Singleton.sharedInstance.interstitial?.isReady {
            Singleton.sharedInstance.interstitial?.presentFromRootViewController(self)
        }
    }
    
    //Interstitial delegate
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        println("interstitialDidFailToReceiveAdWithError:\(error.localizedDescription)")
        Singleton.sharedInstance.interstitial = createAndLoadInterstitial()
    }
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        /////hereeeeeeee
        println("interstitialDidReceiveAd")
       // presentInterstitial()
    }
    
    func interstitialWillDismissScreen(ad: GADInterstitial!) {
        println("interstitialWillDismissScreen")
        dispatch_async(dispatch_get_main_queue(), {
          /*  self.button.hidden = false
            self.tempView.hidden = false
            self.loadingView.hidden = true
            self.shouldStopRotating = true
            self.tableView.reloadData()
            self.tableView.hidden = false*/
        })
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        println("interstitialDidDismissScreen")
    }
    
    func interstitialWillLeaveApplication(ad: GADInterstitial!) {
        println("interstitialWillLeaveApplication")
    }
    
    func interstitialWillPresentScreen(ad: GADInterstitial!) {
        println("interstitialWillPresentScreen")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
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
          feedbackString = NSString(format:"%.0lfmi",val) as String
        }else{
          feedbackString = NSString(format: "%.1lfmi", val) as String
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
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                //this occurs if location is set to allowed but there was an error retrieving it
                print("BRANDON TEST")
                let alertController = UIAlertController(
                    title: "Well...",
                    message: "Looks like your location is ON but your phone cant find your location. Try closing this app and reopening it.",
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as! CLLocation
            self.coord = locationObj.coordinate
            
            Singleton.sharedInstance.lat = self.coord.latitude
            Singleton.sharedInstance.long = self.coord.longitude
            println("createAndLoadInterstitial")
            Singleton.sharedInstance.interstitial = createAndLoadInterstitial()
            println(self.coord.latitude)
            println(self.coord.longitude)
            locationManager.stopUpdatingLocation()
        }
        
    }
    func foodAction(sender: UIButton!) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Button Press", label: "Food Button", value: nil).build() as AnyObject as! [NSObject : AnyObject])
        Singleton.sharedInstance.madeRequest = "food"
        
        if(Singleton.sharedInstance.zipcode){
            var address = self.myTextField.text
             Singleton.sharedInstance.madeRequestLoc = address
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error)->Void in
                if error == nil {
                    if let placemark = placemarks?[0] as? CLPlacemark {
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Zip Code Used", label: "Food Button", value: nil).build() as AnyObject as! [NSObject : AnyObject])
                        Singleton.sharedInstance.lat = placemark.location.coordinate.latitude
                        Singleton.sharedInstance.long = placemark.location.coordinate.longitude
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                        let vc = TableViewController() //change this to your class name
                        self.navigationController?.pushViewController(vc,animated:true)
                    }else{
                        //error couldnt find location
                        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Zip Code Used", label: "Geocoder could not locate place", value: nil).build() as AnyObject as! [NSObject : AnyObject])
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
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Zip Code Used", label: "Geocoder could not locate place", value: nil).build() as AnyObject as! [NSObject : AnyObject])
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
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "User Location Used", label: "Food Button", value: nil).build() as AnyObject as! [NSObject : AnyObject])
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = TableViewController() //change this to your class name
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }
    func barAction(sender: UIButton!) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Button Pressed", label: "Bar Button", value: nil).build() as AnyObject as! [NSObject : AnyObject])
        Singleton.sharedInstance.madeRequest = "bar"
        if(Singleton.sharedInstance.zipcode){
        var address = self.myTextField.text
        Singleton.sharedInstance.madeRequestLoc = address
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error)->Void in
            if error == nil {
                if let placemark = placemarks?[0] as? CLPlacemark {
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Zip Code Used", label: "Bar Button", value: nil).build() as AnyObject as! [NSObject : AnyObject])
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
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Zip Code Used", label: "Geocoder could not locate place", value: nil).build() as AnyObject as! [NSObject : AnyObject])
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
                 tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Zip Code Used", label: "Geocoder could not locate place", value: nil).build() as AnyObject as! [NSObject : AnyObject])
                let cancelAction = UIAlertAction(title: "Close", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        }else{
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "User Location Used", label: "Bar Button", value: nil).build() as AnyObject as! [NSObject : AnyObject])
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = TableViewController() //change this to your class name
            self.navigationController?.pushViewController(vc,animated:true)
        }
    }
    func zipcodeAction(sender: UIButton!) {
        let tracker = GAI.sharedInstance().defaultTracker
        Singleton.sharedInstance.zipcode = true
        if(myTextField.userInteractionEnabled){
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Button Pressed", label: "Zip Code OFF", value: nil).build() as AnyObject as! [NSObject : AnyObject])
            myTextField.userInteractionEnabled = false
            let buttonImageNormal = UIImage(named: "locationIcon")
            sender.setImage(buttonImageNormal, forState: .Normal)
            sender.setImage(buttonImageNormal,forState: .Highlighted)
            self.myTextField.text = ""
            self.myTextField.placeholder = "Current Location"
            Singleton.sharedInstance.zipcode = false
        }else{
            tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Button Pressed", label: "Zip Code ON", value: nil).build() as AnyObject as! [NSObject : AnyObject])
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
            let tracker = GAI.sharedInstance().defaultTracker
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Location Status", label: "Restricted", value: nil).build() as AnyObject as! [NSObject : AnyObject])
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Location Status", label: "User denied access to location", value: nil).build() as AnyObject as! [NSObject : AnyObject])
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Location Status", label: "Status not determined", value: nil).build() as AnyObject as! [NSObject : AnyObject])
                manager.requestWhenInUseAuthorization()
            default:
                locationStatus = "Allowed to location Access"
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Location Status", label: "Allowed to location Access", value: nil).build() as AnyObject as! [NSObject : AnyObject])
                shouldIAllow = true
            }
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                //show zip code input field
                NSLog("Denied access: \(locationStatus)")
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Front Page", action: "Location Status", label: "Denied access: \(locationStatus)", value: nil).build() as AnyObject as! [NSObject : AnyObject])
                println("createAndLoadInterstitial")
                Singleton.sharedInstance.interstitial = createAndLoadInterstitial()
            }
    }


}