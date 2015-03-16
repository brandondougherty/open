//
//  TableViewController.swift
//  Grubber
//
//  Created by brandon dougherty on 11/3/14.
//  Copyright (c) 2014 brandon dougherty. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TableViewController:UIViewController, GADBannerViewDelegate, GADInterstitialDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate,MKMapViewDelegate  {
    let RADIUS:Int = 5000
    let APIKey: String = "AIzaSyAEYAoIJXeiPhTCfDOb28LsPMDnrUqZDT4"
    var mapView: MKMapView! = MKMapView()
    var markerNumber:Int = 0
    var markers = [Marker]()
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var coord : CLLocationCoordinate2D!
    var locationManager: CLLocationManager! = nil
    var types:NSArray?
    var name:String?
    var priceLevel:Int?
    var rating:Double?
    var vicinity:String?
    var phone:String?
    var refreshControler: UIRefreshControl!  = nil // An optional variable
    var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    var imageCache = NSMutableDictionary()
    var tableView : UITableView!
    var tempView : UIView!
    var gmaps: GMSMapView?
    var button: UIButton!
    var loadingView: UIButton!
    //Animations
  
    var snap: UISnapBehavior!
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    var snapBehavior1 : UISnapBehavior!
    var animator1: UIDynamicAnimator!
    
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    var isRotating = false
    var shouldStopRotating = false
    var timer: Timer!
    
    //search bar
    var searchBar :UISearchBar!
    var searchDisplayControllers : UISearchDisplayController!
    
    //Ads  
    var interstitial:GADInterstitial?
    var loadRequestAllowed = true
    var bannerDisplayed = false
    let statusbarHeight:CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Singleton.sharedInstance.zipcode != true){
            initLocationManager();
        }
        navigationController?.navigationBar.hidden = false
        self.view.backgroundColor = UIColor.whiteColor()
       //HOME BUTTON
        let buttonImageBack = UIImage(named: "backIcon") as UIImage?
        let buttonBack   = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        buttonBack.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        buttonBack.frame = CGRectMake(20, 20, 30, 50)
        buttonBack.setImage(buttonImageBack, forState: .Normal)
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        //self.title = "Open"
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 103, height: 35))
        imageView.contentMode = .ScaleAspectFit
        // 4
        let image = UIImage(named: "headerlogo")
        imageView.image = image
        // 5
        
        navigationItem.titleView = imageView
        
        self.tableView = UITableView(frame: CGRectMake(0, self.view.frame.height/2 - 30,self.view.frame.width, self.view.frame.height), style: UITableViewStyle.Plain)
        
        var nib = UINib(nibName: "Cell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 65
        //map container
        self.tempView = UIView(frame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 30, self.view.frame.size.width, self.view.frame.height/2))

        //pull to refresh
        self.refreshControler = UIRefreshControl()
        //self.refreshControler.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControler.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        self.view.addSubview(self.tableView)
        self.view.addSubview(self.tempView)
      
        
        
        self.tempView.hidden = true
        self.tableView.addSubview(refreshControler)
        var tblView =  UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.tableFooterView?.hidden = true
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorInset = UIEdgeInsetsZero
        
        self.button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(self.view.frame.width/2-30, self.view.frame.size.height/2, 60, 60)
        button.setImage(UIImage(named: "mapButton"), forState: .Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let panGesture = UIPanGestureRecognizer(target: self, action: "buttonAction :")
        button.addGestureRecognizer(panGesture)
        
        button.layer.cornerRadius = 10.0
        self.view.addSubview(button)
        self.button.hidden = true
        if(Singleton.sharedInstance.zipcode){
            self.loadStuff()
        }
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //myTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    //Interstitial func
    func createAndLoadInterstitial()->GADInterstitial {
        println("createAndLoadInterstitial")
        var interstitial = GADInterstitial()
        interstitial.delegate = self
        interstitial.adUnitID = "ca-app-pub-1449159202125999/8102937464"
        var requestAd = GADRequest()
        if(coord != nil){
            requestAd.setLocationWithLatitude(CGFloat(Singleton.sharedInstance.lat), longitude: CGFloat(Singleton.sharedInstance.long), accuracy: 10000)
        }
        requestAd.testDevices = [ GAD_SIMULATOR_ID ];
        interstitial.loadRequest(requestAd)
        
        return interstitial
    }
    
    func presentInterstitial() {
        if let isReady = interstitial?.isReady {
            interstitial?.presentFromRootViewController(self)
        }
    }
    
    //Interstitial delegate
    func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
        println("interstitialDidFailToReceiveAdWithError:\(error.localizedDescription)")
        interstitial = createAndLoadInterstitial()
    }
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        
        println("interstitialDidReceiveAd")
        presentInterstitial()
    }
    
    func interstitialWillDismissScreen(ad: GADInterstitial!) {
        println("interstitialWillDismissScreen")
        dispatch_async(dispatch_get_main_queue(), {
            self.button.hidden = false
            self.tempView.hidden = false
            self.loadingView.hidden = true
            self.shouldStopRotating = true
            self.tableView.reloadData()
            self.tableView.hidden = false
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
    

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if self.shouldStopRotating == false {
            self.loadingView.rotate360Degrees(completionDelegate: self)
        } else {
            self.reset()
        }
    }
   

    func reset() {
        self.isRotating = false
        self.shouldStopRotating = false
    }
    func popToRoot(sender:UIBarButtonItem){
        Singleton.sharedInstance.page = 0;
        interstitial = nil
          navigationController?.navigationBar.hidden = true
        navigationController?.popToRootViewControllerAnimated(true)
    }
    func buttonAction(sender: UIButton!) {
       animateMapPanelYPositionY(targetPosition: self.view.frame.origin.y - (self.view.frame.height/2) + 64)
       
        self.tableView.frame.size.height = self.view.frame.size.height
        self.tableView.frame.origin.y =  0
        button.removeTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.addTarget(self, action: "returnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let panGesture = UIPanGestureRecognizer(target: self, action: "returnAction:")
        let panGesture1 = UIPanGestureRecognizer(target: self, action: "buttonAction:")
        button.removeGestureRecognizer(panGesture1)
        button.addGestureRecognizer(panGesture)
    }
    func returnAction(sender: UIButton!) {
        animateMapPanelYPositionY(targetPosition: 30)
        self.tableView.frame.size.height = self.view.frame.size.height/2 + 30
        self.tableView.frame.origin.y = self.view.frame.size.height/2 - 30
        button.removeTarget(self, action: "returnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        let panGesture = UIPanGestureRecognizer(target: self, action: "returnAction:")
        button.removeGestureRecognizer(panGesture)
        let panGesture1 = UIPanGestureRecognizer(target: self, action: "buttonAction:")
        button.addGestureRecognizer(panGesture1)
    }
    func animateMapPanelYPositionY(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.tempView.frame.origin.y = targetPosition
            self.button.frame.origin.y = (self.view.frame.size.height/2) - 10 + targetPosition
            }, completion: completion)
    }
 
    func refresh(sender:AnyObject)
    {
        //Singleton.sharedInstance.locations = [Location]()
        initLocationManager();
        self.refreshControler.endRefreshing()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* var count:Int
        if(Singleton.sharedInstance.locations.count < 20){
            return Singleton.sharedInstance.locations.count - 1
        }else{
            if(Singleton.sharedInstance.page == Singleton.sharedInstance.maxPage){
                return Singleton.sharedInstance.locations.count - 1
            }else{
                return 20 + (Singleton.sharedInstance.page * 20) + 1
            }
        }*/
        return Singleton.sharedInstance.locations.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRowIndex = indexPath
        if(Singleton.sharedInstance.cellExpansionArray[indexPath.row] == 1)
        {
        Singleton.sharedInstance.cellExpansionArray[indexPath.row] = 0
        }else{
            Singleton.sharedInstance.cellExpansionArray[indexPath.row] = 1
        }
        tableView.beginUpdates();
         let cell: TableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell

        dispatch_async(dispatch_get_main_queue(), {
            //animate annotation view
            var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(cell.latitude), longitude:  CLLocationDegrees(cell.longitude))
            let region = MKCoordinateRegion(center: target, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView!.setRegion(region, animated: true)
            
            UIView.animateWithDuration(0.15, animations: {
                cell.numberIconBackground.transform = CGAffineTransformMakeScale(0.9, 0.9)
                },completion: {(_) -> Void in
                    UIView.animateWithDuration(0.15, animations: {
                        cell.numberIconBackground.transform = CGAffineTransformMakeScale(1, 1)
                        
                    })
            })
            
        })
        tableView.endUpdates();
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex.row && Singleton.sharedInstance.cellExpansionArray[indexPath.row] == 1{
            
            return self.view.frame.size.height/2 - 30
        }
        return 70
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell: TableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as TableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        if(Singleton.sharedInstance.locations.count != 0){
          // if(indexPath.row < Singleton.sharedInstance.locations.count){
                let Stores = Singleton.sharedInstance.locations[indexPath.row]
                cell.listNumber.text = String(indexPath.row + 1)
            cell.loadItem(name:Stores.name ,open:Stores.open_now, location: Stores.vicinity, timeLeft: Stores.howMuchLonger,hoursToday: Stores.hours, nextHours: Stores.nextHours, yestHour: Stores.yestHour,phone: Stores.phone,lat: Stores.lat, long : Stores.long, dist: Stores.distance )
           // if (indexPath.row == 20 + (Singleton.sharedInstance.page * 20) - 2 && Singleton.sharedInstance.page <= Singleton.sharedInstance.maxPage)
           //   {
                    //Singleton.sharedInstance.page++;
                    //println(Singleton.sharedInstance.page)
                  //  dispatch_async(dispatch_get_main_queue(), {
                    //    self.tableView.reloadData()// println("tabvleview ready")
                        
                    //})
                    
               // }
           //}
        }
        return cell
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
            var locationObj = locationArray.lastObject as CLLocation
            self.coord = locationObj.coordinate
            println("createAndLoadInterstitial")
            interstitial = createAndLoadInterstitial()
            Singleton.sharedInstance.lat = self.coord.latitude
            Singleton.sharedInstance.long = self.coord.longitude
            println(self.coord.latitude)
            println(self.coord.longitude)
            locationManager.stopUpdatingLocation()
            self.loadStuff()
        }
  
    }
    func loadStuff(){
        println("createAndLoadInterstitial")
        interstitial = createAndLoadInterstitial()
        //MAP
        mapView.mapType = .Standard
        mapView.frame = CGRectMake(0, 0, self.tempView.frame.width, self.tempView.frame.height)
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.tempView.addSubview(mapView)
        var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:  Singleton.sharedInstance.lat, longitude:  Singleton.sharedInstance.long)
        
        let region = MKCoordinateRegion(center: target, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
        mapView.setRegion(region, animated: true)
        
        //loading wheel
        self.loadingView = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        loadingView.frame = CGRectMake(self.view.frame.width/2-25, self.view.frame.height/2 - 25, 50, 50)
        let loadImage = UIImage(named: "baricon")
        loadingView.setImage(loadImage, forState: .Normal)
        loadingView.enabled = false
        self.view.addSubview(loadingView)
        
        self.loadingView.rotate360Degrees(duration:2.0, completionDelegate: self)
        // Perhaps start a process which will refresh the UI...
        self.timer = Timer(duration: 50.0, completionHandler: {
            self.shouldStopRotating = true
        })
        self.timer.start()
        self.isRotating = true
        self.loadingView.hidden = false
        self.tableView.hidden = true
        if(Singleton.sharedInstance.madeRequest != Singleton.sharedInstance.previousRequest || Singleton.sharedInstance.sliderValue != Singleton.sharedInstance.sliderRequestValue || Singleton.sharedInstance.madeRequestLoc != Singleton.sharedInstance.prevMadeRequestLoc)
        {
            Singleton.sharedInstance.locations = [Location]()
            Singleton.sharedInstance.previousRequest = Singleton.sharedInstance.madeRequest
            Singleton.sharedInstance.prevMadeRequestLoc = Singleton.sharedInstance.madeRequestLoc
            var urlString = "https://maps.googleapis.com/maps/api/place/radarsearch/json?location=\(Singleton.sharedInstance.lat),\(Singleton.sharedInstance.long)&radius=\(Int(Singleton.sharedInstance.sliderValue))&types=\(Singleton.sharedInstance.madeRequest)&opennow=true&key=\(APIKey)" // Your Normal URL String
            println(urlString)
            let manager = Manager.sharedInstance
            manager.request(.GET, urlString)
                .response {
                    (request, response, data, error) -> Void in
                    println(response)
                    let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data as NSData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                    Singleton.sharedInstance.sliderRequestValue = Singleton.sharedInstance.sliderValue
                    let results: NSArray = json["results"] as NSArray
                    var resultCount: Int? = results.count
                    if (resultCount == 0)
                    {
                        println("no results")
                        
                    }else{
                        for var i = 0; i < resultCount; i++ {
                            Singleton.sharedInstance.i += 1
                            
                            let geometry: NSDictionary = results[i]["geometry"]! as NSDictionary
                            let location: NSDictionary = geometry["location"]! as NSDictionary
                            let lat: Double = location["lat"] as Double
                            let long: Double = location["lng"] as Double
                            let placeId: String = results[i]["place_id"] as String
                            var open_now: Int?
                            var todayshour: String?
                            var tomhours : String?
                            var yestHours: String?
                            var result: Int = 0
                            var urlString1 = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(self.APIKey)"
                            manager.request(.GET, urlString1)
                                .response {
                                    (request, response, data, error) -> Void in
                                    let jsonPlace: NSDictionary = NSJSONSerialization.JSONObjectWithData(data as NSData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                                    if let resultsPlace: NSDictionary = jsonPlace["result"]! as? NSDictionary{
                                        
                                        if let types = resultsPlace["types"]as AnyObject? as? NSArray{
                                            self.types = resultsPlace["types"] as? NSArray
                                        }else{
                                            self.types = []
                                        }
                                        if let rating = resultsPlace["rating"]as AnyObject? as? Double{
                                            self.rating = resultsPlace["rating"]! as? Double
                                        }else{
                                            self.rating = 0.0
                                        }
                                        if let vicinity = resultsPlace["vicinity"]as AnyObject? as? String{
                                            self.vicinity = resultsPlace["vicinity"]! as? String
                                        }else{
                                            self.vicinity = ""
                                        }
                                        if let priceLevel = resultsPlace["price_level"] as AnyObject? as? Int{
                                            self.priceLevel = resultsPlace["price_level"]! as? Int
                                        }else{
                                            self.priceLevel = 0
                                        }
                                        let icon: String = resultsPlace["icon"]! as String
                                        let name: String = resultsPlace["name"]! as String
                                        if let phone = resultsPlace["formatted_phone_number"] as AnyObject? as? String{
                                            self.phone = resultsPlace["formatted_phone_number"]! as? String
                                        }else{
                                            self.phone = "unknown"
                                        }
                                        
                                        if let open: NSDictionary = resultsPlace["opening_hours"] as? NSDictionary {
                                            open_now = open["open_now"] as? Int
                                            // remeber to check if opening_hours exists so it doesnt crash
                                            let opening_hours: NSDictionary = resultsPlace["opening_hours"] as NSDictionary
                                            let periods: NSArray = opening_hours["periods"] as NSArray
                                            
                                            if(periods.count > 1){
                                                if let closeTimes: NSArray = periods.valueForKey("close") as? NSArray{
                                                    //get current time
                                                    let date = NSDate()
                                                    let calendar = NSCalendar.currentCalendar()
                                                    let components = calendar.components(.WeekdayCalendarUnit | .CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
                                                    var hour = components.hour
                                                    let minutes = components.minute
                                                    let weekday = components.weekday-1
                                                    // println(closeTimes)
                                                    println(weekday)
                                                    
                                                    var todayshours: NSMutableArray = opening_hours["weekday_text"] as NSMutableArray
                                                    todayshours.insertObject(todayshours[6], atIndex: 0)
                                                    todayshour = todayshours[components.weekday - 1] as? String
                                                    
                                                    if(components.weekday > 6){
                                                        tomhours = todayshours[0] as? String
                                                    }else{
                                                        tomhours = todayshours[components.weekday] as? String
                                                    }
                                                    if(components.weekday - 2 < 0){
                                                        yestHours = todayshours[6] as? String
                                                    }else{
                                                        yestHours = todayshours[components.weekday - 2] as? String
                                                    }
                                                    var closeTimesArray:[String] = []
                                                    //dual open close times per day
                                                    for(idx, theDay) in enumerate(closeTimes){
                                                        var day:Int = theDay.valueForKey("day") as Int
                                                        var time:String = theDay.valueForKey("time") as String
                                                        if(closeTimes.count == 7){
                                                            if(idx == weekday){
                                                                closeTimesArray.append(time)
                                                            }
                                                        }else{
                                                            if(day == weekday){
                                                                closeTimesArray.append(time)
                                                            }
                                                        }
                                                    }
                                                    
                                                    //   println(closeTimesArray)
                                                    var minutesUntil = 60 - minutes
                                                    var result:Int
                                                    if(closeTimesArray.count > 1)
                                                    {
                                                        //multiple close times throughout the day
                                                        var close1: Int? = closeTimesArray[0].toInt()
                                                        var close2: Int? = closeTimesArray[1].toInt()
                                                        var time = (hour*100) + minutes
                                                        //if first close time has passed already
                                                        if(close1 < time){
                                                            //and if second close time is before 12pm (for places that close at 1am or later)
                                                            if(close2 < 1200){
                                                                result = self.minutesUntilClose(close2! + 2400,hour: hour,minute: minutesUntil)
                                                            }else{
                                                                result = self.minutesUntilClose(close2!,hour: hour,minute: minutesUntil)
                                                            }
                                                        }else{
                                                            if(close1 < 1200){
                                                                result = self.minutesUntilClose(close1!+2400,hour: hour,minute: minutesUntil)
                                                                
                                                            }else{
                                                                result = self.minutesUntilClose(close1!,hour: hour,minute: minutesUntil)
                                                            }
                                                        }
                                                    }
                                                    else if(closeTimesArray.count == 1)
                                                    {
                                                        var closing:Int? = closeTimesArray[0].toInt()
                                                        //closing is 2130 hour is 2100
                                                        if(Int(closing!/100) == hour){
                                                            result = closing! - (hour * 100) - minutesUntil
                                                        }
                                                        if(closing < 1200){
                                                            result = self.minutesUntilClose(closing!+2400,hour: hour,minute: minutesUntil)
                                                            
                                                        }else{
                                                            result = self.minutesUntilClose(closing!,hour: hour,minute: minutesUntil)
                                                        }
                                                        
                                                    }else{
                                                        //something went wrong and we dont know the close time
                                                        //parse from string version?
                                                        result = 5
                                                    }//update UI
                                                    
                                                }//if close times
                                            }//if periods count
                                        }//opening hours
                                        var pinCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long);
                                        var pin: MapPin = MapPin(coordinate: pinCoord, title: "test", subtitle: "tets")
                                        var item = Marker(id: placeId,marker: pin)
                                        if let open_now = open_now{
                                            
                                        }else{
                                            open_now = 0
                                        }
                                        if let todayshour = todayshour{
                                            
                                        }else{
                                            todayshour = "This place should be open!"
                                        }
                                        if let tomhours = tomhours{
                                            
                                        }else{
                                            tomhours = "This place should be open!"
                                        }
                                        if let yestHours = yestHours{
                                            
                                        }else{
                                            yestHours = "This place should be open!"
                                        }
                                        //  println(result)
                                        var dis1 = CLLocation(latitude: Singleton.sharedInstance.lat, longitude: Singleton.sharedInstance.long).distanceFromLocation(CLLocation(latitude: lat, longitude: long))
                                        var dis2 = Double(dis1 * 0.000621371)
                                        var dis : String = ""
                                        if(dis2 < 1.0){
                                             dis = String(format: "%.1fmi", dis2)
                                        }else{
                                             var dis2 = Int(dis1 * 0.000621371)
                                            dis = String("\(dis2.description)mi")
                                        }
                                        
                                        var user = Location(
                                            placeId: placeId,
                                            types : self.types!,
                                            name : name,
                                            rating : self.rating!,
                                            vicinity: self.vicinity!,
                                            priceLevel: self.priceLevel!,
                                            open_now: open_now!,
                                            icon: icon,
                                            lat: lat,
                                            long: long,
                                            howMuchLonger: result,
                                            hours: todayshour!,
                                            nextHours: tomhours!,
                                            yestHour: yestHours!,
                                            pin: item,
                                            phone: self.phone!,
                                            distance: dis
                                        )
                                        Singleton.sharedInstance.locations.append(user)
                                        //we have loaded all the places
                                        println("SINGLETON \(Singleton.sharedInstance.locations.count) Result Count: \(resultCount)")
                                        if(Singleton.sharedInstance.locations.count == resultCount){
                                            Singleton.sharedInstance.locations.sort { $0.distance < $1.distance }
                                            Singleton.sharedInstance.maxPage = Int(Singleton.sharedInstance.locations.count/20)
                                            
                                            println("Count:\(Singleton.sharedInstance.locations.count)")
                                            println("maxPage:\(Singleton.sharedInstance.maxPage)")
                                        }
                                        
                                    }//result
                                    
                            }//end second request
                        }
                        
                    }
            }
            
        }//end if made request statement
    }
   func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
            for var x = 0; x < Singleton.sharedInstance.locations.count - 1; x++ {
                println(x)
                var markerCoords:CLLocationCoordinate2D = Singleton.sharedInstance.locations[x].pin.marker.coordinate
                
                var pin: MapPin = MapPin(coordinate: markerCoords, title: String(x+1), subtitle: Singleton.sharedInstance.locations[x].name)
                mapView.addAnnotation(pin)
            }
    
    }
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
        let reuseId = "test\(annotation.title)"
    
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
        
            var label:UILabel = UILabel(frame: CGRect(x: 0, y: 9, width: 40, height: 20))
            if (annotation.title == "Current Location"){
            }else{
                label.text = annotation.title
                
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                anView.image = UIImage(named:"pin")
                anView.canShowCallout = true
                label.font = UIFont(name: "Arial-BoldItalicMT", size: 12)
                label.textAlignment = .Center;
                anView.addSubview(label)
            }
            
        }
        else {
        //we are re-using a view, update its annotation reference...
            
            var label:UILabel = UILabel(frame: CGRect(x: 0, y: 9, width: 40, height: 20))
            if (annotation.title == "Current Location"){
                
            }else{
                label.text = annotation.title
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                anView.image = UIImage(named:"pin")
                anView.canShowCallout = true
                label.font = UIFont(name: "Arial-BoldItalicMT", size: 12)
                label.textAlignment = .Center;
                anView.addSubview(label)
            }
           
        }
        return anView
    }
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
         println(view.annotation.title)
        if let annotations = view{
            if(annotations.annotation.title != "Current Location"){
                println(annotations.annotation.title)
            let row : String = String(annotations.annotation.title!)
            let rowInt : Int = row.toInt()!
            
            dispatch_async(dispatch_get_main_queue(), {
                //animate annotation view
                UIView.animateWithDuration(0.2, animations: {
                    annotations.transform = CGAffineTransformMakeScale(0.8, 0.8)
                },completion: {(_) -> Void in
                        UIView.animateWithDuration(0.2, animations: {
                            annotations.transform = CGAffineTransformMakeScale(1, 1)
                            var scrollIndexPath : NSIndexPath = NSIndexPath(forRow: rowInt, inSection: 0)
                            var scrollIndexPath2 : NSIndexPath = NSIndexPath(forRow: rowInt - 1, inSection: 0)
                            self.tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: .Middle, animated: true)
                            self.tableView(self.tableView, didSelectRowAtIndexPath: scrollIndexPath2);
                        })
                })
                //scroll to cell
                
            })
            }
        }
    }
    //calculates number of minutes till closing time.
    // close = close time in military time
    // hour = in single digit ex. 15 = 3pm
    func  minutesUntilClose(close:Int,hour:Int,minute:Int)-> Int{
        
        var hoursUntil = (close)-((hour+1)*100)
        if(hoursUntil >= 59){
            hoursUntil = (hoursUntil/100)*60
        }
        var result = Int(hoursUntil) + minute
        println(result)
        return result
    }
   
   func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                //show zip code input field
                NSLog("Denied access: \(locationStatus)")
                println("createAndLoadInterstitial")
                interstitial = createAndLoadInterstitial()
            }
    }
}
