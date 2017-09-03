//
//  Message.swift
//  Rippl
//
//  Created by mike hargrove on 12/29/14.
//  Copyright (c) 2014 mike hargrove. All rights reserved.
//

import Foundation
import UIKit

class Message : NSObject {
    
    override init()  {
        
    }
  
    func fromMessageQueue (messageQueue:MessageQueue!)  {

        self.messageId = messageQueue.messageIdentifier! as String
        self.content = messageQueue.message! as String
        self.disposition = messageQueue.disposition.integerValue
        self.createDate = messageQueue.postDateTime;
        self.latitude = messageQueue.latitude.doubleValue
        self.longitude = messageQueue.longitude.doubleValue
        
    }

    
    var messageId : String = ""
    var content : String = ""
    var userId : String = "";
    var createDate : NSDate = NSDate();
    var expirationDate : NSDate = NSDate();
    var longitude : Double = 0.0;
    var latitude : Double = 0.0;
    var privacy : Bool = false;
    var disposition : Int = 0;
    var ttl : Int = 0;
    
    
/*
    var recipient : String = ""
    var precision : Double = 0
    var userIdentifier : String = ""
    var postDateTime : NSDate = NSDate()
    var executionDateTime : NSDate = NSDate()
    var disposition: Int = 0;
*/
    
    
    
    func asJSON() -> Dictionary<String, AnyObject>  {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // superset of OP's format
        
        let jsonObject: [String: AnyObject] = [
            "messageId": messageId,
            "content": content,
            "userId": userId,
            //"ttl": ttl,
            //"createDate": dateFormatter.stringFromDate(createDate),
            //"expirationDate": dateFormatter.stringFromDate(expirationDate),
            "longitude": longitude,
            "latitude": latitude,
            "privacy": privacy
            ,"disposition": disposition
        ]
        
        return jsonObject;
        
    }
    
    
    func getMessageHeight(width:CGFloat) -> CGFloat  {
        
        let util = Utility();
        
        var height : CGFloat = 0.0;
        
        height = util.defaultOwnerLabelHeight() + 8 + util.heightForView(content, font: util.defaultFont(), width: width)
        
        
        return height;
        
    }
    
 /*
    func formatMessagePut() -> String  {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // superset of OP's format
        
        var postDateTimeValue = "";
        postDateTimeValue = dateFormatter.stringFromDate(postDateTime);
        
        var request : String = "";
        
        request += "{\n "
        request += "\"aoc\":\"message\",\n \"action\":\"put\",\n "
        request += " \"username\": \"\(userIdentifier)\",\n"
        request += " \"recipient\": \"\(recipient)\",\n"
        request += " \"message\": \"\(message)\",\n"
        request += " \"messageIdentifier\": \"\(messageIdentifier)\",\n"
        request += " \"latitude\": \(location.latitude),\n"
        request += " \"longitude\": \(location.longitude),\n"
        request += " \"postDateTime\": \"\(postDateTimeValue)\",\n"
        request += " \"precision\": \(precision)\n"
        request += " }"
        
        //print(request)
        
        
        return request
        
        
    }
    
    
    
    

    
    func formatMessageDisposition(username : String) -> String  {
        
        var request : String = "";
        
        request += "{\n "
        request += "\"aoc\":\"message\",\n \"action\":\"disposition\",\n "
        request += " \"user_identifier\": \"\(username)\",\n"
        request += " \"message_identifier\": \"\(messageIdentifier)\",\n"
        request += " \"executionDateTime\": \"\(executionDateTime)\",\n"
        request += " \"disposition\": \(disposition)\n"
        request += " }"
        
        print(request);
        
        
        return request
        
        
    }
    
    
    func formatCheck(username : String, location : Location, lastCheck:String) -> String  {
        var request : String = "";
        
        request += "{\n "
        request += "\"aoc\":\"message\",\n \"action\":\"check\",\n "
        request += " \"userIdentifier\": \"\(username)\",\n"
        request += " \"last_check\": \"\(lastCheck)\",\n"
        request += " \"latitude\": \(location.latitude),\n"
        request += " \"longitude\": \(location.longitude)\n"
        request += " }"
        
        return request
        
        
    }
 
 */
    
}