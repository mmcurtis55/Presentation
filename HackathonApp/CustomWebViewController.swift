//
//  MainViewController.swift
//  HackathonApp
//
//  Created by Matthew Curtis on 8/3/15.
//  Copyright (c) 2015 Matthew Curtis. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import CoreBluetooth

class CustomWebViewController: UIViewController, BeaconScannerDelegate{
    
    var beaconScanner: BeaconScanner!

    let minorURL = [44176:"https://www.facebook.com", 33662 : "www.freescale.com"]
    
    //Test
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "F7826DA6-4FA2-4E98-8024-BC5B71E0893E"), identifier: "OHT-FSL")
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var bookmarkButton: UIToolbar!
    
    var useLocationServices = true
    var locMan: CLLocationManager?
    var initialHeading: Double = 0
    
    var searchResults = []
    
    @IBOutlet weak var testBeaconLabel: UILabel! //delete later
    @IBOutlet weak var beaconLabel: UILabel! // the label that shows beacon info "North V-Bldg"
    @IBOutlet weak var clMessage: UILabel! // the label  used to display the heading
    
    //allows use of CoreData
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else  {
            return nil
        }
        }()


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view, typically from a nib.
        self.revealViewController().rearViewRevealWidth = 120
        self.revealViewController().rearViewRevealOverdraw = 30
        
        //Web stuff
        let url = NSURL (string: "https://www.google.com");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        
        
        //EDDYSTONE
        self.beaconScanner = BeaconScanner()
        self.beaconScanner!.delegate = self
        self.beaconScanner!.startScanning()
        
        
        //Test
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
        
        //Beacon stuff
        if locManager != nil {
            locMan = locManager!
            locMan!.delegate = self
        }

    }
    
    
    // Mark - UIView Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        locMan!.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        locMan!.stopUpdatingHeading()
        locMan!.delegate = nil
    }

    
    func preview(dataUrlStr: String) {
        var docUrl = NSURL(fileURLWithPath: dataUrlStr)
        // if scheme is "file", then the format is just the file name like foo.json or foo.png
        if docUrl?.scheme! == "file" {
            let fileNameWithoutExt = dataUrlStr.stringByDeletingPathExtension
            let ext = dataUrlStr.pathExtension
            docUrl = NSBundle.mainBundle().URLForResource(fileNameWithoutExt, withExtension: ext)
        }
        
        if (docUrl != nil) {
            let req = NSURLRequest(URL: docUrl!)
            webView.loadRequest(req)
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Saving links
    @IBAction func bookmarkURL(sender:UIBarButtonItem){
        println("bookmarked")
    }
    
    
    // MARK: EDDYSTONE stuff
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        NSLog("FIND: %@", beaconInfo.description)
    }
    func didLoseBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        
    }
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        NSLog("UPDATE: %@", beaconInfo.description)
    }

    
    
    
   


}
extension CustomWebViewController: CLLocationManagerDelegate {
    // MARK: Web

    // updateUI(beacon: CLBeacon)
    
    func beaconIdent()->String{
        //if nearestBeaconDidChange(){
        lastBeaconDisplayed = lastBeacon
        let beacon  = lastBeacon!
        switch lastBeacon!.minor.integerValue {
        case 10472:
            let detailLabel:String = "Major: \(beacon.major.integerValue), " +
                "Minor: \(beacon.minor.integerValue), " +
                "RSSI: \(beacon.rssi as Int), " +
            "UUID: \(beacon.proximityUUID.UUIDString)"
            println("open map for \(detailLabel)")
            beaconLabel.text = "J1"
            
        case 44176:
            let detailLabel:String = "Major: \(beacon.major.integerValue), " +
                "Minor: \(beacon.minor.integerValue), " +
                "RSSI: \(beacon.rssi as Int), " +
            "UUID: \(beacon.proximityUUID.UUIDString)"
            println("open map for \(detailLabel)")
            
            
            let url = NSURL (string: "https://facebook.com");
            let requestObj = NSURLRequest(URL: url!);
            webView.loadRequest(requestObj);
            
            beaconLabel.text = "E3"
        case 23996:
            let detailLabel:String = "Major: \(beacon.major.integerValue), " +
                "Minor: \(beacon.minor.integerValue), " +
                "RSSI: \(beacon.rssi as Int), " +
            "UUID: \(beacon.proximityUUID.UUIDString)"
            println("open map for \(detailLabel)")
            
            beaconLabel.text = "W1"
            
        case 33662:
            let detailLabel:String = "Major: \(beacon.major.integerValue), " +
                "Minor: \(beacon.minor.integerValue), " +
                "RSSI: \(beacon.rssi as Int), " +
            "UUID: \(beacon.proximityUUID.UUIDString)"
            println("open map for \(detailLabel)")
            
            let url = NSURL (string: "https://freescale.com");
            let requestObj = NSURLRequest(URL: url!);
            webView.loadRequest(requestObj);
            
            beaconLabel.text = "W1"
            
        case 46621:
            let detailLabel:String = "Major: \(beacon.major.integerValue), " +
                "Minor: \(beacon.minor.integerValue), " +
                "RSSI: \(beacon.rssi as Int), " +
            "UUID: \(beacon.proximityUUID.UUIDString)"
            println("open map for \(detailLabel)")
            
            beaconLabel.text = "D1"
            
        default:
            // blank out
            beaconLabel.text = "Unrecognized"
            break
        }
        return beaconLabel.text!
        //}
        // return "WHAT HAPPENED"
    }
    
    
    
    func loadMapForBeacon(){
        preview("\(beaconIdent()).pdf")
        //begins fetch of coreData entity with name SiteNavMap
//        let fetchReq = NSFetchRequest(entityName: "SiteNavMap")
//        
//        //sorts request by date
//        fetchReq.sortDescriptors = [NSSortDescriptor(key: "timeAdded", ascending: false)]
//        
//        //finalizes results as an array of type [SiteNavMap]?
//        let fetchResults = managedObjectContext!.executeFetchRequest(fetchReq, error: nil) as? [SiteNavMap]
//        
//        //checks if the fetchedResults array object's mapPDF atribute has been set or is still nil. This is common when working with optionals
//        
//        var bas: NSManagedObject!
//        
//        for bas: AnyObject in fetchResults!
//        {
//            managedObjectContext!.deleteObject(bas as! NSManagedObject)
//        }
//        
//        //time object is selected. Will be used for sorting in order by date and time to find most recently viewed map
//        //var todaysDate:NSDate = NSDate()  // no longer needed
//        
//        //inserts a new SiteNavMap object
//        var SNM = NSEntityDescription.insertNewObjectForEntityForName("SiteNavMap",
//            inManagedObjectContext: self.managedObjectContext!) as! SiteNavMap
//        
//        var path = "\(beaconIdent()).pdf"
//        //sets mapPDF and timeAdded atributes.
//        SNM.mapPDF = path
//        //SNM.timeAdded = todaysDate
        println("called loadMapFomBeacon but commented out")
        
        
    }
    
    
    
    
    private func degreesToRadians(angle: Double) -> CGFloat {
        let rad = (angle) / 180.0 * M_PI
        let ret_val = CGFloat(rad)
        return ret_val
    }
    
    
    // from http://stackoverflow.com/questions/7490660/converting-wind-direction-in-angles-to-text-words
    private func degToCompass(num: Double) -> String {
        let directions = ["N","NNE","NE","ENE","E","ESE", "SE", "SSE","S","SSW","SW","WSW","W","WNW","NW","NNW"]
        let index = Int((num/22.5) + 0.5) % 16
        return directions[index]
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        
        if initialHeading == 0 {
            // initialHeading = newHeading.trueHeading
        }
        // TODO: this will rotate the whole page but it is not working quite right
        //webView.transform = CGAffineTransformMakeRotation(degreesToRadians(initialHeading - newHeading.trueHeading));
        
        // add code here for heading info
        let compassStr = degToCompass(newHeading.trueHeading)
        let str = NSString(format: "%.1f", newHeading.trueHeading)
        clMessage?.text = "\(compassStr) (\(str))"
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        switch error.code {
        case CLError.Denied.rawValue:
            clMessage?.text = "Location Services Off"
            println("\(error)")
        case CLError.HeadingFailure.rawValue:
            clMessage?.text = "Compass Heading Failure"
        default:
            println("\(error)")
        }
        
    }
    
    func nearestBeaconDidChange() -> Bool{
        return lastBeacon != lastBeaconDisplayed
        
    }
    
    
    func nearestBeaconChanged(nearestBeacon: CLBeacon) {
        lastBeacon = nearestBeacon
        //set nil to allow lastBeacon != lastBeaconDisplayed  to be true
        lastBeaconDisplayed = nil
        //loadMapForBeacon(nearestBeacon)
    }
    
    func nearestProximityChanged(nearestBeacon: CLBeacon) {
        lastProximity = nearestBeacon.proximity;
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        //beaconLabel.text = beacons.first?.minor.description
        var message:String = ""
        
        // get the nearest beacon... this is the beacon with RSS closest to 0 but not zero
        if (beacons.count > 0) {
            
            var nearestBeacon:CLBeacon?
            for beacon in beacons as! [CLBeacon] {
                if beacon.rssi < 0 {
                    nearestBeacon = beacon
                    break
                }
            }
            
            // if we have a nearestbeacon
            if (nearestBeacon != nil) {
                if lastBeacon == nil {
                    nearestBeaconChanged(nearestBeacon!)
                    testBeaconLabel.text = "\(lastBeacon!.minor) : \(beaconIdent())"
                } else {
                    // not nil check the minor number
                    if lastBeacon?.minor == nearestBeacon!.minor {
                        if(nearestBeacon!.proximity == lastProximity || nearestBeacon!.proximity == CLProximity.Unknown) {
                            //testBeaconLabel.text = "\(lastBeacon!.minor) : \(beaconIdent())"
                            return  // same so return
                        } else {
                            // the beacon is changed
                            nearestProximityChanged(nearestBeacon!)
                        }
                        return
                    } else {
                        // different so the beacon must be different
                        lastBeaconDisplayed = nearestBeacon!
                        nearestBeaconChanged(nearestBeacon!)
                        //self.notification.displayNotificationWithMessage("Entered \(beaconIdent()) Building. Beacon : \(lastBeacon!.minor)", duration: 2.0)
                        testBeaconLabel.text = "\(lastBeacon!.minor) : \(beaconIdent())"
                        
                    }
                    
                }
            }
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if let clBeaconRegion = region as? CLBeaconRegion {
            clBeaconRegion
            //self.notification.displayNotificationWithMessage("Hello, World!", duration: 1.0)
            println("You entered the region")
            testBeaconLabel.text = "Entered the region"
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            println("You exited the region")
            beaconLabel.text = "Exited the region"
    }
    
    
}