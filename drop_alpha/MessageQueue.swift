//
//  MessageQueue.swift
//  Rippl
//
//  Created by mike hargrove on 3/23/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import Foundation
import CoreData

@objc(MessageQueue)
class MessageQueue: NSManagedObject {

    @NSManaged var message: String?
    @NSManaged var messageIdentifier: String?
    @NSManaged var userIdentifier: String?
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var postDateTime: NSDate
    
    @NSManaged var disposition: NSNumber
    @NSManaged var dispositionLat: NSNumber
    @NSManaged var dispositionLong: NSNumber
    @NSManaged var dispositionExecutionDateTime: NSDate



    @NSManaged var precision: NSNumber

    
    /*
    
    func stringForDate() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        if let date = date {
            return dateFormatter.stringFromDate(date)
        } else {
            return ""
        }
    }
    
    func csv() -> String {
        
        let coalescedHeight = height ?? ""
        let coalescedPeriod = period ?? ""
        let coalescedWind = wind ?? ""
        let coalescedLocation = location ?? ""
        var coalescedRating:String
        if let rating = rating?.intValue {
            coalescedRating = String(rating)
        } else {
            coalescedRating = ""
        }
        
        return "\(stringForDate()),\(coalescedHeight)," +
            "\(coalescedPeriod),\(coalescedWind)," +
        "\(coalescedLocation),\(coalescedRating)\n"
    }

   */
    
    func toMessage() -> Message  {
        
        let messageToReturn:Message = Message();
  
        
        if let coalesedMessage:String = message  {
            messageToReturn.content = coalesedMessage;
        }
        else {
            messageToReturn.content = "";
        }
        
        
        if let coalesedUserIdenfier:String = userIdentifier  {
            messageToReturn.userId = coalesedUserIdenfier;
        }
        else {
            messageToReturn.userId = "";
        }
        
        
        
        if let coalMessageIdentifier:String = messageIdentifier {
            messageToReturn.messageId = coalMessageIdentifier
        }
        else {
            messageToReturn.messageId  = "";
        }
        
        //messageToReturn.location = Location();
        
        if let coalLongitude:Double = longitude as Double  {
            messageToReturn.longitude = coalLongitude;
        }
        else {
            messageToReturn.longitude = -1;
        }
        
        
        if let coalLatitude:Double = latitude as Double {
            messageToReturn.latitude = coalLatitude;
        }
        else {
            messageToReturn.latitude = -1;
        }
        
        if let coalDisposition:Int = disposition as Int  {
            messageToReturn.disposition = coalDisposition;
        }
        else {
            messageToReturn.disposition = 0;
        }
        
        if let coalPostDate:NSDate = postDateTime as NSDate  {
            messageToReturn.createDate = coalPostDate;
        }
        else {
            messageToReturn.createDate = NSDate();
        }
 
        return messageToReturn;
    }

}
