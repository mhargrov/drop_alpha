//
//  HomeViewControllerMap.swift
//  Rippl
//
//  Created by mike hargrove on 8/3/16.
//  Copyright © 2016 mike hargrove. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit


extension HomeViewController : MKMapViewDelegate   {
    
        
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        
        
    }
    
    func updateLocation() {
        
        let funcName = "updateLocation()";
        
        Logging.info(className, methodName: funcName, logline:"updateLocation()");
        
        let messaging:Messaging = Messaging();
        
        let locations:[Location] = messaging.getLocations();
        
        if(locations.count > 0)  {
        
            let location:Location = locations.first!;
        
            let mapLocation = CLLocationCoordinate2DMake(location.latitude, location.longitude);
            
            let mapSpan = MKCoordinateSpanMake(0.015, 0.015);
            
            let mapRegion = MKCoordinateRegionMake(mapLocation, mapSpan);
        
            let ann = MKPointAnnotation();
            ann.coordinate = mapLocation;
            ann.title = "Current Location";
            
            self.mapView.addAnnotation(ann);
            
            self.mapView.region = mapRegion;
            
            
        
        }
        
    }
    
}