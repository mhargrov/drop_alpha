//
//  LocationQueue.swift
//  Rippl
//
//  Created by mike hargrove on 4/18/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import Foundation
import CoreData

@objc(LocationQueue)
class LocationQueue: NSManagedObject {

    @NSManaged var userIdentifier: String
    @NSManaged var markDateTime: NSDate
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var course: NSNumber
    @NSManaged var speed: NSNumber
    @NSManaged var disposition: NSNumber
    @NSManaged var altitude: NSNumber
    @NSManaged var horizontalAccuracy: NSNumber
    @NSManaged var locationIdentifier: String
    @NSManaged var placemark : String

    
    func toLocation() -> Location  {
        
        let locationToReturn:Location = Location();
        
        
        locationToReturn.userIdentifier = self.userIdentifier ?? ""
        
        if let coalLongitude:Double = self.longitude as Double  {
            locationToReturn.longitude = coalLongitude;
        }
        else {
            locationToReturn.longitude = -1;
        }
        
        
        if let coalLatitude:Double = latitude as Double {
            locationToReturn.latitude = coalLatitude;
        }
        else {
            locationToReturn.latitude = -1;
        }
        
        
        if let coalCourse:Double = course as Double {
            locationToReturn.course = coalCourse;
        }
        else {
            locationToReturn.course = -1;
        }
        
        
        if let coalSpeed:Double = speed as Double {
            locationToReturn.speed = coalSpeed;
        }
        else {
            locationToReturn.speed = -1;
        }
        
        if let coalAltitude:Double = altitude as Double {
            locationToReturn.altitude = coalAltitude;
        }
        else {
            locationToReturn.altitude = -1;
        }
        
        
        if let coalHorizontalAccuracy:Double = horizontalAccuracy as Double {
            locationToReturn.horizontalAccuracy = coalHorizontalAccuracy;
        }
        else {
            locationToReturn.horizontalAccuracy = -1;
        }
        

        locationToReturn.markDateTime = markDateTime;
        
        if let coalDisposition:Int = disposition as Int  {
            locationToReturn.disposition = coalDisposition;
        }
        else {
            locationToReturn.disposition = 0;
        }

        
        if let coalDisposition:String = locationIdentifier as String  {
            locationToReturn.locationIdentifier = coalDisposition;
        }
        else {
            locationToReturn.locationIdentifier = "";
        }
        
        //if let coalDisposition:String = placemark as String  {
        //    locationToReturn.placemark = coalDisposition;
        //}
        //else {
        //    locationToReturn.placemark = "";
       // }

        
        return locationToReturn;
    }
    
}
