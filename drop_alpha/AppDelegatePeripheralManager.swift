//
//  AppDelegatePeripheralManager.swift
//  Rippl
//
//  Created by mike hargrove on 5/16/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation
import UIKit



extension AppDelegate { // : CBPeripheralManagerDelegate {
    
    
    
    // MARK: Beacon Services
    
    /*
    func startBeacons()  {
      
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        beaconManager = CBPeripheralManager(delegate: self, queue: queue)
        if let pmanager = beaconManager {
            pmanager.delegate = self
        }

    }
    
    func startRangingBeacon(notification:NSNotification)  {
        
        //let funcName = "startRangingBeacon(notification:NSNotification)";
        
        //Logging.log(className, methodName: funcName, logline:"start ranging beacon")
        
        
        
        //var dictionary:[String:String] = Dictionary<String, String>();
        
        //var hasDictionary:Bool = false;
        if let dict:Dictionary<String,String> = notification.userInfo as? [String:String] {
            //dictionary = notification.userInfo as! [String:String];
            
            if let uuidValue:String = dict["uuid"]  {
        //        Logging.log(className, methodName: funcName, logline:"beacon uuid [\(uuidValue)]")
                let uuid:NSUUID = NSUUID(UUIDString: uuidValue)!;
                let region = CLBeaconRegion(proximityUUID: uuid,identifier: "ripplBeacon");
                region.notifyOnEntry = true;
                region.notifyOnExit = true;
                locationManager.startMonitoringForRegion(region);
                locationManager.startRangingBeaconsInRegion(region);
            }
        }
        
        
        
        
    }
    
    func stopRangingBeacon(notification:NSNotification)  {
        
        //let funcName = "stopRangingBeacon(notification:NSNotification)";
        
        //Logging.log(className, methodName: funcName, logline:"start ranging beacon")
        
        
        if let dict:Dictionary<String,String> = notification.userInfo as? [String:String] {
            
            if let uuidValue:String = dict["uuid"]  {
        //        Logging.log(className, methodName: funcName, logline:"beacon uuid [\(uuidValue)]")
                let uuid:NSUUID = NSUUID(UUIDString: uuidValue)!;
                
                for region:CLRegion in locationManager.monitoredRegions  {
                    if let beaconregion = region as? CLBeaconRegion  {
                        if(beaconregion.proximityUUID == uuid)  {
                            locationManager.stopRangingBeaconsInRegion(beaconregion);
                        }
                    }
                }
                
                for region:CLRegion in locationManager.rangedRegions  {
                    if let beaconregion = region as? CLBeaconRegion  {
                        if(beaconregion.proximityUUID == uuid)  {
                            locationManager.stopMonitoringForRegion(beaconregion);
                        }
                    }
                }
                

            }
        }
        
        
        
        
    }
    
 
 */
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        let funcName = "locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)";
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        //Logging.log(className, methodName: funcName, logline:"--> --> --> --> Found [\(knownBeacons.count)] Beacons \(region.identifier): ");
        if(knownBeacons.count > 0)  {
            //Logging.log(className, methodName: funcName, logline:"--> --> --> --> Found [\(knownBeacons.count)] Beacons \(region.identifier): ");
            for beacon in knownBeacons as [CLBeacon]  {
                //Logging.log(className, methodName: funcName, logline:"")
               
                switch beacon.proximity  {
                case .Far:
                    Logging.debug(className, methodName: funcName, logline:"rssi \(beacon.rssi), accuracy \(beacon.accuracy) with the Proximity of = Far")
                case .Immediate:
                    Logging.debug(className, methodName: funcName, logline:"rssi \(beacon.rssi), accuracy \(beacon.accuracy) with the Proximity of = Immediate");
                case .Near:
                    Logging.debug(className, methodName: funcName, logline:"rssi \(beacon.rssi), accuracy \(beacon.accuracy) with the Proximity of = Near");
                default:
                    Logging.debug(className, methodName: funcName, logline:"rssi \(beacon.rssi), accuracy \(beacon.accuracy) with the Proximity of = Unknown");
                }

            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        //let funcName = "localtionManager didStartMonitoringForRegion";
        //Logging.log(className, methodName: funcName, logline:"=======  didStartMonitoringForRegion \(region.identifier)")
        locationManager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == CLRegionState.Inside {
            locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        }
        else {
            locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        }
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError)  {
        let funcName = "locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError)";
        Logging.debug(className, methodName: funcName, logline:"=======  rangingBeaconsDidFailForRegion \(region.identifier)")
        Logging.debug(className, methodName: funcName, logline:"=======\(error.description)")
        
        
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion)  {
        let funcName = "locationManager(manager: CLLocationManager, didExitRegion region: CLRegion)";
        Logging.debug(className, methodName: funcName, logline:"=======You are exiting the region of a beacon " +
            "with an identifier of \(region.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion)  {
        let funcName = "locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion)";
        Logging.debug(className, methodName: funcName, logline:"=======You are entering the region of a beacon " +
            "with an identifier of \(region.identifier)")
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)  {
        
        
        let funcName = "locationManager(manager: CLLocationManager, didFailWithError error: NSError)";
        Logging.debug(className, methodName: funcName, logline:"error code \(error.code) is equal to \(kCLErrorDomain)")
        
        if(error.code == 0)  {
            let funcName = "localtionManager didEnterRegion";
            Logging.debug(className, methodName: funcName, logline:"kCLErrorDomain recognized as a NON error")
        }
        else {
            manager.stopUpdatingLocation()
            let funcName = "localtionManager didEnterRegion";
            Logging.debug(className, methodName: funcName, logline:"stopped updating location")
        }
        
        if(seenError == false)  {
            seenError = true;
            Logging.debug(className, methodName: funcName, logline:error.localizedDescription)
        }
        
    }
    
    
/*
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?){
        
        let funcName = "peripheralManagerDidStartAdvertising";
        
        if error == nil{
            
            Logging.log(className, methodName: funcName, logline:"====== Successfully started advertising our beacon data")
            
            let message = "Successfully set up your beacon. " + "The unique identifier of our service is: \(uuid.UUIDString)"
            
            Logging.log(className, methodName: funcName, logline:message)
            
            
        } else {
            Logging.log(className, methodName: funcName, logline:"====== Failed to advertise our beacon. Error = \(error)")
        }
        
    }
    
*/
    
/*
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager){
        
        let funcName = "peripheralManagerDidStartAdvertising";
        
        peripheral.stopAdvertising()
        
        var stateDescr = "";
        

        switch peripheral.state{
        case .PoweredOff:
            stateDescr = "Powered off"
        case .PoweredOn:
            stateDescr = "Powered on"
        case .Resetting:
            stateDescr = "Resetting"
        case .Unauthorized:
            stateDescr = "Unauthorized"
        case .Unknown:
            stateDescr = "Unknown"
        case .Unsupported:
            stateDescr = "Unsupported"
        }
        
        Logging.log(className, methodName: funcName, logline:"=====The peripheral state is \(stateDescr)")
        
        /* Bluetooth is now powered on */
        if peripheral.state != .PoweredOn{
            /*
            let controller = UIAlertController(title: "Bluetooth",
                message: "Please turn Bluetooth on",
                preferredStyle: .Alert)
            */
            
            
        } else {
            
            let region = CLBeaconRegion(proximityUUID: uuid,
                major: major,
                minor: minor,
                identifier: identifier)
            
            
            
            
 //           let manufacturerData = identifier.dataUsingEncoding(
 //               NSUTF8StringEncoding,
 //               allowLossyConversion: false)
            
 //           let theUUid = CBUUID(NSUUID: uuid)
            
 //           let dataToBeAdvertised:[String: AnyObject!] = [
 //               CBAdvertisementDataLocalNameKey : "ripplBeacon",
 //               CBAdvertisementDataManufacturerDataKey : manufacturerData,
 //               CBAdvertisementDataServiceUUIDsKey : [theUUid],
 //           ]

            var dataDictionary = NSDictionary();
            dataDictionary = region.peripheralDataWithMeasuredPower(nil);
            
            
            //var dataToBeAdvertised:[NSObject:AnyObject] = region.peripheralDataWithMeasuredPower(nil)
            
            peripheral.startAdvertising(dataDictionary as? [String : AnyObject])
            
        }
        
    }
*/
    
    
}