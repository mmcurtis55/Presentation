//
//  AppDelegate.swift
//  HackathonApp
//
//  Created by Matthew Curtis on 8/3/15.
//  Copyright (c) 2015 Matthew Curtis. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import CoreLocation

var locManager: CLLocationManager?

// ibeacon stuff
var lastProximity: CLProximity?
var lastBeacon: CLBeacon?
var lastBeaconDisplayed: CLBeacon?


var infoPlist: NSDictionary? = {
    if let bundle = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
        if let info = NSDictionary(contentsOfFile: bundle) as? Dictionary<String, AnyObject> {
            return info
        } else {
            return nil
        }
    } else {
        
        return nil
    }
    }()



/**
* This function allows logging to occur when DEBUG flag is set.
* When the code
* See the following for more information
* http://stablekernel.com/blog/ios-build-configurations-and-schemes/
*/
func DLog(message: String, function: String = __FUNCTION__) {
    #if DEBUG
        NSLog("\(function): \(message)")
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // TODO: read bundle based on user defined macro
        
        // Override point for customization after application launch.
        // Register the preference defaults early.
        if let bundle = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
            if let appDefaults = NSDictionary(contentsOfFile: bundle) as? Dictionary<String, AnyObject> {
                NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
            }
        }
        
        // Other initialization...
        
        // Branding
        // DD540B
        // E66A08
        // 230 106 8
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(rgba: "#e66a08")
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        
        locManager = CLLocationManager()
        
        if (locManager != nil) {
            locManager!.requestWhenInUseAuthorization()
        }
        
        locManager!.pausesLocationUpdatesAutomatically = false
        locManager!.startUpdatingLocation()
        
        // setupBeacon
        let uuidString = "F7826DA6-4FA2-4E98-8024-BC5B71E0893E"
        let beaconIdentifier = "OHT-FSL"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
        
        // this tells you if you are with in range
        locManager!.startMonitoringForRegion(beaconRegion)
        
        // this tells you the details of the range (immed, near, far,  unknown)
        locManager!.startRangingBeaconsInRegion(beaconRegion)
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
        }
        
        // new Relic Monitoring
        //        NewRelicAgent.startWithApplicationToken("AA011ee8ec951b042aec571302599c0dd4cf4f2b4e")
        
        // AFNetworking
        #if DEBUG
            AFNetworkActivityLogger.sharedLogger().startLogging()
        #endif
        return true
    }
    
    
        func triggerLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                if locManager!.respondsToSelector("requestWhenInUseAuthorization") {
                    locManager!.requestWhenInUseAuthorization()
                } else {
                    startUpdatingLocation()
                }
            }
        }
    
        func startUpdatingLocation() {
            locManager!.startUpdatingLocation()
        }
    
        // MARK: - CLLocationManagerDelegate
    
        func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            if status == .AuthorizedAlways {
                if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                    if CLLocationManager.isRangingAvailable() {
                       startUpdatingLocation()
                    }
                }
            }
        }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.MatthewCurtis.HackathonApp" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("HackathonApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("HackathonApp.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

