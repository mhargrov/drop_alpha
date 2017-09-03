//
//  AppDelegateCoreLocation.swift
//  Rippl
//
//  Created by mike hargrove on 5/16/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

extension AppDelegate : CLLocationManagerDelegate  {
    
    


    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        let funcName = "localtionManager didChangeAuthorizationStatus";
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
        //NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            
            Logging.log(className, methodName: funcName, logline:"Location to Allowed")
            // Start location services
            //if(manager!.)
            //manager!.startUpdatingLocation()
        } else {
            Logging.debug(className, methodName: funcName, logline:"Denied access: \(locationStatus)")
        }
        
        Logging.debug(className, methodName: funcName, logline:"access: \(locationStatus)")
        
        
    }
    
    // MARK: Location Services
    
    func startLocationUpdates() {
        
        let funcName = "startLocationUpdates";
        
        locationManager = CLLocationManager()
        
        if(CLLocationManager.locationServicesEnabled())  {
            Logging.debug(className, methodName: funcName, logline:"location services enabled");
        }
            else {
            Logging.debug(className, methodName: funcName, logline:"location services not enabled")
        }
        
        seenError = false;
        locationFixAchieved = false;
        
        
        if(CLLocationManager.locationServicesEnabled())  {
            Logging.debug(className, methodName: funcName, logline:"location services enabled");
        }
            else {
            Logging.debug(className, methodName: funcName, logline:"location service not enabled")
        }
        
        if(!CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion))  {
            Logging.debug(className, methodName: funcName, logline:"monitoring is not avialable for device");
        }

        if(!CLLocationManager.isRangingAvailable())  {
            Logging.debug(className, methodName: funcName, logline:"ranging is not avialable for device");
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            Logging.debug(className, methodName: funcName, logline:"requesting authorization")
            if(locationManager!.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization))) {
            Logging.debug(className, methodName: funcName, logline:"selector requestAlwaysAuthorization enabled");
            self.locationManager!.requestAlwaysAuthorization()
            }
            if(locationManager!.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)))  {
                Logging.debug(className, methodName: funcName, logline:"selector requestWhenInUseAuthorization enabled");
                self.locationManager!.requestWhenInUseAuthorization()
            }
            
        }
            else {
            Logging.debug(className, methodName: funcName, logline:"not request authorization status")
        }
        
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways
                || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse)  {
            
                    
                    //this with enable continous location updates
                    //locationManager!.startUpdatingLocation()
            Logging.debug(className, methodName: funcName, logline:"started updating location")
            }
                else {
                Logging.debug(className, methodName: funcName, logline:"Not Authorized")
        }
        
        //kCLLocationAccuracyNearestTenMeters
       
        locationManager!.delegate = self;
        locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager!.requestLocation();
        Logging.debug(className, methodName: funcName, logline:"completed engagement")
        
        
    }

    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let funcName = "locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])";
        
        locationFixAchieved = true
        let locationArray = locations as NSArray
        
        let username:String = self.prefs.objectForKey("UUID") as! String
        
        let notificationMarkLocations = NSNotification(name:"updateLocation", object:nil)
        NSNotificationCenter.defaultCenter().postNotification(notificationMarkLocations)
        
        //Logging.log(className, methodName: funcName, logline:"location array count \(locationArray.count) time: \(NSDate())");
        //var newAddress : Bool = false;
        
        //var locationLast:CLLocation!
        for location:CLLocation in locationArray as! [CLLocation]  {
            //let coord = location.coordinate
            
            //var doesExist:Bool = false;
            
            
            
            /*
            for locationQueue:LocationQueue in persistedLocations  {
            if(coord.latitude == locationQueue.latitude && coord.longitude == locationQueue.longitude) {
            doesExist = true;
            }
            }
            */
            Logging.info(className, methodName: funcName, logline:"lat  \(location.coordinate.latitude), long \(location.coordinate.longitude), course\(location.course), speed \(location.speed), alt \(location.altitude),horizontal \(location.horizontalAccuracy)")
            
            
            var isNewLocation = false;
            var clearzeros = false;
            
            if(self.lastLatitude == 0 || self.lastLongitude == 0)  {
                self.lastLatitude = location.coordinate.latitude
                self.lastLongitude = location.coordinate.longitude
                
                clearzeros  = true;
            }
            
            if((lastLatitude != location.coordinate.latitude) || (lastLongitude != location.coordinate.longitude) || (clearzeros))  {
                
                self.lastLatitude = location.coordinate.latitude
                self.lastLongitude = location.coordinate.longitude
                //Logging.log(className, methodName: funcName, logline:"latitude  \(location.coordinate.latitude), longitude \(location.coordinate.longitude), course\(location.course), speed \(location.speed), altitude \(location.altitude),horizontalAccuracy \(location.horizontalAccuracy)")
                //Logging.log(className, methodName: funcName, logline:"lastLatitude [\(lastLatitude)] lastLongitude [\(lastLongitude)] ");
                isNewLocation = true;
                
                let fetchRequest = NSFetchRequest(entityName: "LocationQueue")
                //let sortDescriptor = NSSortDescriptor(key: "markDateTime", ascending: false)
                //fetchRequest.sortDescriptors = [sortDescriptor]
                
                let predicatePlus = NSPredicate(format: "disposition = %@ AND latitude =%d AND longitude = %d", "-1", location.coordinate.latitude, location.coordinate.longitude)
                
                // Set the predicate on the fetch request
                fetchRequest.predicate = predicatePlus
                fetchRequest.resultType = .CountResultType
                var result:[NSNumber];
                
                do {
                    result = try persistence.context!.executeFetchRequest(fetchRequest) as! [NSNumber]
                }
                catch {
                    result = [0];
                }
                
                
                let count = result[0].integerValue ;
                //Logging.log(className, methodName: funcName, logline:"count of existing locations [\(count)]");
                if(count>1)  {
                    isNewLocation = false;
                }
                
                
                
            }
            Logging.info(className, methodName: funcName, logline:"isNewLocation \(isNewLocation)")
            
            
            //println("doesExist \(doesExist)")
            
            if(isNewLocation)  {
                
                let messaging:Messaging = Messaging();
                
                let uuid:NSUUID = NSUUID();
                
                let locationToSave:Location = Location();
                locationToSave.locationIdentifier = uuid.UUIDString;
                locationToSave.longitude = location.coordinate.longitude;
                locationToSave.latitude = location.coordinate.latitude;
                locationToSave.course = location.course;
                locationToSave.speed = location.speed;
                locationToSave.markDateTime = location.timestamp;
                locationToSave.horizontalAccuracy = location.horizontalAccuracy
                locationToSave.userIdentifier = username
                locationToSave.disposition = -1;
                locationToSave.altitude = location.altitude
                
                messaging.addLocation(locationToSave);
              
            
                let longitudeGC :CLLocationDegrees = location.coordinate.longitude
                let latitudeGC :CLLocationDegrees = location.coordinate.latitude
            
                let locationtoGeoCode = CLLocation(latitude: latitudeGC, longitude: longitudeGC);
                
            
                CLGeocoder().reverseGeocodeLocation(locationtoGeoCode, completionHandler: {(placemarks, error) -> Void in
                
                    if error != nil {
                        Logging.info(self.className, methodName: funcName, logline:"Reverse geocoder failed with error" + error!.localizedDescription)
                        return
                    }
                
                    Logging.log(self.className, methodName: funcName, logline:"placemark count \(placemarks?.count)")
                
                    if placemarks!.count > 0 {
                        
                        //for placemark:CLPlacemark in placemarks! {
                        //    Logging.info(self.className, methodName: funcName, logline:"placemark name [\(placemark.name)]");
                        //}

                        //if let pm:CLPlacemark = placemarks![0] {
                        //    let placemark:String = pm.name! as String;
                        //    Logging.info(self.className, methodName: funcName, logline:"placemark name [\(placemark)]");
                        //}
                        
                        if let pm:CLPlacemark = placemarks?.first {
                            let placemark:String = pm.name! as String;
                            let msging:Messaging = Messaging();
                            msging.updateLocationPlacemark(locationToSave.locationIdentifier, placemark: placemark)
                            Logging.info(self.className, methodName: funcName, logline:"placemark name [\(placemark)]");
                        }
                        
                        
                    }
                    else {
                        Logging.log(self.className, methodName: funcName, logline:"Problem with the data received from geocoder")
                    }
                })
                
                
               
            
                
           }// new location
                

        } //loop
        
        
        persistence.saveContext();
        
 
     
    }
    

    

    
}
