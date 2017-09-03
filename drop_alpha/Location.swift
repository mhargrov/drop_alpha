//
//  Location.swift
//  Rippl
//
//  Created by mike hargrove on 4/16/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import Foundation


class Location : NSObject {
    
    override init()  {   }

    
    var locationIdentifier : String = "";
    var longitude: Double = 0.0;
    var latitude: Double = 0.0;
    var course: Double = 0.0;
    var speed: Double = 0.0;
    var altitude: Double = 0.0;
    var horizontalAccuracy: Double = 0.0;
    var markDateTime:NSDate = NSDate();
    var userIdentifier:String = "";
    var disposition:Int = 0;
    var placemark:String = "";
 
    
    func formatMark() -> String  {
        
        var request : String = "";
        
        
        
        request += "{\n "
        request += "\"aoc\":\"location\",\n \"action\":\"mark\",\n "
        request += " \"userIdentifier\": \"\(userIdentifier)\",\n"
        request += " \"longitude\": \"\(longitude)\",\n"
        request += " \"latitude\": \"\(latitude)\",\n"
        request += " \"course\": \"\(course)\",\n"
        request += " \"speed\": \(speed),\n"
        request += " \"altitude\": \(altitude),\n"
        request += " \"markDateTime\": \"\(markDateTime)\",\n"
        request += " \"horizontalAccuracy\": \(horizontalAccuracy)\n"
        request += " }"
        
        //println(request)
        
        
        return request
        
        
    }
    
}