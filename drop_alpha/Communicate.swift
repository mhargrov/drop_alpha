//
//  Communicate.swift
//  Rippl
//
//  Created by mike hargrove on 12/14/14.
//  Copyright (c) 2014 mike hargrove. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class Communicate : NSObject   {
    
    let className = "Communicate";
    
    
    let messaging:Messaging = Messaging();
    
    
    func getError() -> NSError {
        return responseError!;
    }

    
     var responseError: NSError?
    
    func dispositionMessages(persistence:Persistence, messages:[Message], userIdentifier:String)  {
        
        //let funcName = "dispositionMessages";
        
        
     
        for message:Message in messages  {
            
      
            //println("processing message \(message.messageIdentifier)");
            let checkRequest:String = ""; //message.formatMessageDisposition(userIdentifier)

            //Logging.log(className, methodName: funcName, logline:"disposition request \(checkRequest)")
            
            
            //self.sendReqest(checkRequest, withType: Constants().kAPI_MESSAGE)

            let post:NSString = checkRequest.stringByReplacingOccurrencesOfString("\n", withString: "   ")
            
            //println("postdata: \(post)");
            let url:NSURL = NSURL(string: Constants().kAPI_MESSAGE)!
            //Logging.log(className, methodName: funcName, logline:"url \(url)");
            
            let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            
            Alamofire.request(.GET, Constants().kAPI_MESSAGE)
                .validate()
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
            }
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            
            let sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration();
            //sessionConfig.
               
            let session = NSURLSession(configuration: sessionConfig);
            
            let task = session.dataTaskWithRequest(request, completionHandler: { urlData, response, error -> Void in
                    
                if error != nil {
                        //callback("", error.localizedDescription)
                } else {
                        
                        
                        //var result = NSString(data: data!, encoding:NSASCIIStringEncoding)!

                        if (urlData != nil ) {
                            let res = response as! NSHTTPURLResponse!;
                            
                            //Logging.log(self.className, methodName: funcName, logline:"Response code: \(res.statusCode)");
                            
                            if (res.statusCode >= 200 && res.statusCode < 300)  {
                                
                                //let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                                
                              //  Logging.log(className, methodName: funcName, logline:"Response ==> %@", responseData);
                                
                                do {
                                
                                
                                    let jsonData:NSDictionary = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
                                    
                                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                                
                                    //Logging.log(self.className, methodName: funcName, logline:"success \(success)");
                                    
                                    
                                    if(success>0) {
                                        
                                        let fetchRequestCompleted = NSFetchRequest(entityName: "MessageQueue");
                                        let predicateMessage = NSPredicate(format: "messageIdentifier == %@", message.messageId);
                                        fetchRequestCompleted.predicate = predicateMessage;
                                        let messagesFound = try persistence.context!.executeFetchRequest(fetchRequestCompleted) as! [MessageQueue!]
                                        //Logging.log(self.className, methodName: funcName, logline:"found message to delete count \(messagesFound.count)");
                                        
                                        
                                        if(message.disposition ==  -20)  {
                                            for mqw:MessageQueue in messagesFound  {
                                                mqw.disposition = Constants().kDISPOSITION_UNDEFINED
                                            }
                                        }
                                        else {
                                            for mqw:MessageQueue in messagesFound  {
                                                persistence.context!.deleteObject(mqw);
                                            }
                                        }
                                        persistence.saveContext();
                                        
                                                
                                     
                                    }

                                }// end do
                                catch {
                                    print(error);
                                }
                                
                            }
                        } //if url data is not nil
                        
                    }

            })
            task.resume()

        }
        
        
    }
    
    func retrieveJsonFromData(data: NSData){
        
        let funcName = "retrieveJsonFromData";
        
        /* Now try to deserialize the JSON object into a dictionary */
        var error: NSError?
        
        let jsonObject: AnyObject?
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data,
                        options: .AllowFragments)
        } catch let error1 as NSError {
            error = error1
            jsonObject = nil
        }
        
        if  error == nil{
            
            //Logging.log(className, methodName: funcName, logline:"Successfully deserialized...")
            
            if jsonObject is NSDictionary{
                //let deserializedDictionary = jsonObject as! NSDictionary
                //Logging.log(className, methodName: funcName, logline:"Deserialized JSON Dictionary = \(deserializedDictionary)")
            }
            else if jsonObject is NSArray{
                //let deserializedArray = jsonObject as! NSArray
                //Logging.log(className, methodName: funcName, logline:"Deserialized JSON Array = \(deserializedArray)")
            }
            else {
                /* Some other object was returned. We don't know how to
                deal with this situation as the deserializer only
                returns dictionaries or arrays */
            }
        }
        else if error != nil{
            Logging.log(className, methodName: funcName, logline:"An error happened while deserializing the JSON data.")
        }
        
    }
    
    
    
    

    
    
    

    func markLocation(persistence:Persistence, locations:[Location])  {
       
        let funcName = "markLocation";
        
        Logging.debug(className, methodName: funcName, logline:"locations count \(locations.count)");
        
        if(locations.count > 0)  {
            
            for location: Location in locations  {
       
                Logging.debug(className, methodName: funcName, logline:"location request: latitude \(location.latitude), longitude \(location.longitude)");
        
     
                var urlWithValues :String = "";
            
                urlWithValues.appendContentsOf(Constants().kAPI_LOCATION);
                urlWithValues.appendContentsOf("mark/");
                urlWithValues.appendContentsOf(location.userIdentifier);
                urlWithValues.appendContentsOf("/longitude/");
                urlWithValues.appendContentsOf(String(location.longitude));
                urlWithValues.appendContentsOf("/latitude/");
                urlWithValues.appendContentsOf(String(location.latitude));
            
            
                
                Alamofire.request(.GET, urlWithValues)
                    .validate()
                    .response { (request, response, data, error) -> Void in
                    
                        //printDebug(response)
                    
                        Logging.debug(self.className, methodName: funcName, logline:"found status code \(response?.statusCode)")
                    
                        if response?.statusCode == 200 {
                            Logging.debug(self.className, methodName: funcName, logline:"success with status code \(response?.statusCode)")
                            self.messaging.deleteLocation(location);
                            //let resJson = JSON(responseObject.result.value!)
                            //success(resJson)
                        }
                        if response?.statusCode != 200 {
                            Logging.debug(self.className, methodName: funcName, logline:"failure with status code \(response?.statusCode)")
                            //let error : NSError = responseObject.result.error!
                            //failure(error)
                        }
                }
            
            }// loop persisted locations
            
            


           }// count of locations sent in is ? 0
        
    }
    

        
    func jsonToString(dictionary:AnyObject) ->  String  {
    
        
        do {

            
            let jsonData: NSData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            return String(data: jsonData, encoding: NSUTF8StringEncoding)!
            
        } catch let error as NSError {
            print(error)
        }
        
        return "";
        
    }
    
    func messageCheck(persistence:Persistence, userIdentifier:String, location:Location, lastCheck:String)  {
        
        let funcName = "messageCheck";
        
//        var recievedMessages:[Message] = [];
        
        //"/messages/{userId}/lastLocation"

        
      //  let message : Message = Message()
        
        
        var messageEnpoint :String = Constants().kAPI_MESSAGE
        messageEnpoint.appendContentsOf(userIdentifier);
        messageEnpoint.appendContentsOf("/lastLocation");
        
        Alamofire.request(.GET, messageEnpoint)
            .validate()
            .responseJSON { (response) -> Void in
                
                
                
                
                Logging.debug(self.className, methodName: funcName, logline:self.jsonToString(response.result.value!));
                
                Logging.debug(self.className, methodName: funcName, logline:"found status code \(response.response!.statusCode)")
                
                if response.response!.statusCode == 200 {
                    Logging.debug(self.className, methodName: funcName, logline:"success with status code \(response.response!.statusCode)")
                   
                    let json = JSON(response.result.value!);
                    
                    let jsonMessages:[JSON] = json.array!;
                    
                    var messages : [String] = [];
                    
                    for jsonMessage:JSON in jsonMessages {
                        
                        //var jsonMessage = jsonM.dictionary;
                        
                        let messageId = jsonMessage["messageId"].stringValue;
                        let userId = jsonMessage["userId"].stringValue;
                        let content = jsonMessage["content"].stringValue;
                        let disposition = jsonMessage["disposition"].intValue;
                        let latitude = jsonMessage["latitude"].doubleValue;
                        let longitude = jsonMessage["longitude"].doubleValue;
                        let privacy = jsonMessage["privacy"].boolValue;
                        
                        let message : Message = Message();
                        message.messageId = messageId;
                        message.userId = userId;
                        message.content = content;
                        message.disposition = disposition;
                        message.latitude = latitude;
                        message.longitude = longitude;
                        message.privacy = privacy;
                        
                        messages.append(message.messageId);
                        
                        let countOfMessage : Int = self.messaging.countMessage(message);
                        Logging.debug(self.className, methodName: funcName, logline:" count \(countOfMessage) of message id \(message.messageId)")

                        if(countOfMessage == 0)  {
                           self.messaging.addMessage(message, disposition: Constants().kDISPOSITION_RECIEVED);
                        }
                        
                    }
                    
                    if(messages.count > 0)  {
                        let notification = NSNotification(name:"messagesRecieved", object:nil)
                        NSNotificationCenter.defaultCenter().postNotification(notification);
                    }
                    
                    
                   
                }
                if response.response!.statusCode != 200 {
                    Logging.debug(self.className, methodName: funcName, logline:"failure with status code \(response.response!.statusCode)")
                    
                }
        }

        /*
        
        let checkRequest = ""; //message.formatCheck(userIdentifier, location:location, lastCheck: lastCheck)
        
        //println("checkRequest \(checkRequest)")
            
        //self.sendReqest(checkRequest, withType: Constants().kAPI_MESSAGE)
        
        let post:NSString = checkRequest.stringByReplacingOccurrencesOfString("\n", withString: "   ")
        
        //println("postdata: \(post)");
        let url:NSURL = NSURL(string: Constants().kAPI_MESSAGE)!
        //Logging.log(className, methodName: funcName, logline:"url \(url)");
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        
        let session = NSURLSession.sharedSession();
        
        let task = session.dataTaskWithRequest(request, completionHandler: { urlData, response, error -> Void in
            
            if error != nil {
                //callback("", error.localizedDescription)
            } else {
                
                
                if (urlData != nil ) {
            
                    let res = response as! NSHTTPURLResponse!;
                    if (res.statusCode >= 200 && res.statusCode < 300)  {

                        //let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                        
                        //Logging.log(self.className, methodName: funcName, logline:"Response ==> \(responseData)");
                        
                        let jsonData: AnyObject?
                        do {
                            jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,
                                        options: NSJSONReadingOptions.AllowFragments)
                        } catch  {
                         Logging.log(self.className, methodName: funcName, logline:"error \(error)")
                            jsonData = nil
                        }

                        //Logging.log(self.className, methodName: funcName, logline:"json data is nil \(jsonData == nil)")
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // superset of OP's format
                        
                        if let messagesContainer = jsonData as? NSDictionary {
                            if let messages = messagesContainer["messages"] as? NSArray  {
                                for dict in messages  {
                                    let recievedMessage:Message =  Message();
                            
                                    //parse message
                                    if let uuid = dict["uuid"] as? NSString {
                                        recievedMessage.messageId = uuid as String;
                                    }
                            
                                    if let owner = dict["owner"] as? NSString  {
                                        recievedMessage.userId = owner as String;
                                    }
                            
                                    if let message = dict["message"] as? NSString  {
                                        recievedMessage.content = message as String;
                                    }
                            
                                    //if let precision = dict["precision"] as? Double {
                                    //    recievedMessage.precision = precision as Double;
                                    //}
                                    
                                   
                                    //Logging.log(self.className, methodName: funcName, logline:"about to parse post date")
                                    if let postDateValue = dict["postDate"] as? NSString  {
                                        //Logging.log(self.className, methodName: funcName, logline:"\(postDateValue)");
                                        let postDate = dateFormatter.dateFromString(postDateValue as String);
                                        if let pd = postDate {
                                            recievedMessage.createDate = pd;
                                        }
                                    }
                                    //Logging.log(self.className, methodName: funcName, logline:"finished parsing postDate");
                                
                                    /*
                                    if let expirationDateValue = dict["postDate"] as? NSString  {
                                        let expirationDate = dateFormatter.dateFromString(expirationDateValue as String);
                                        recievedMessage.executionDateTime = expirationDate!;
                                    }
                                    */
                                    /*
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // superset of OP's format
                                    lastMessageCheckDateTime = dateFormatter.stringFromDate(NSDate())
                                    */
                                    
                                    //add to array
                                    if(recievedMessage.messageId != "" )  {
                                        recievedMessages.append(recievedMessage)
                                    }
                                }
                            }

                        }

              

                    }// response code is valid
            
                }  // data is not null
                
                
                Logging.log(self.className, methodName: funcName, logline:" message count \(recievedMessages.count)")
                
                //process new messages
                if(recievedMessages.count > 0)   {
                    
                    do {
                        
                        let fetchRequest = NSFetchRequest(entityName: "MessageQueue")
                        let sortDescriptor = NSSortDescriptor(key: "postDateTime", ascending: false)
                        
                        fetchRequest.sortDescriptors = [sortDescriptor]
                        
                        
                        
                        let predicate = NSPredicate(format: "disposition <> %@", "20")
                        
                        // Set the predicate on the fetch request
                        fetchRequest.predicate = predicate
                        
                        let persistedMessages = try persistence.context!.executeFetchRequest(fetchRequest) as! [MessageQueue!]
                        
                        //Logging.log(self.className, methodName: funcName, logline:"persisted message count \(persistedMessages.count)")
                        
                        var persistedMessageIds:[String] = [];
                        
                        if(persistedMessages.count > 0) {
                            for mq in persistedMessages {
                                //Logging.log(self.className, methodName: funcName, logline:"persisted message \(mq.messageIdentifier)")
                                persistedMessageIds.append(mq.messageIdentifier as String);
                            }
                        }
                        
                       
                        
                        for m:Message in recievedMessages  {
                            var exists:Bool = false;
                            
                            for messageId in persistedMessageIds  {
                                if(messageId == m.messageId)  {
                                    exists = true;
                                }
                            }
                            
                            if(!exists)  {
                                Logging.log(self.className, methodName: funcName, logline:"exists \(exists)")
                            }
                            
                            if(!exists)  {
                                
                                Logging.log(self.className, methodName: funcName, logline:"creating persistent message \(m.content)")
                                let messageQueueRow = NSEntityDescription.insertNewObjectForEntityForName("MessageQueue", inManagedObjectContext: persistence.context!) as! MessageQueue;
                                messageQueueRow.messageIdentifier = m.messageId;
                                messageQueueRow.message = m.content;
                                messageQueueRow.latitude = m.latitude;
                                messageQueueRow.longitude = m.longitude;
                                messageQueueRow.userIdentifier = m.userId;
                                //messageQueueRow.precision = m.precision;
                                messageQueueRow.postDateTime = m.createDate;
                                messageQueueRow.disposition = Constants().kDISPOSITION_RECIEVED;
                                persistence.saveContext();
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    } catch {
                        //TODO
                    }
                    
                    
                }  //recieved message count > 0

                } //error is not null
            
            });//end send

        task.resume();
*/
        //let notification = NSNotification(name:"messagesRecieved", object:nil)
        //NSNotificationCenter.defaultCenter().postNotification(notification);
        
        
    }
    
    func postMessages(persistence:Persistence, messages:[Message])   {
        
        let funcName = "postMessages";

        Logging.log(className, methodName: funcName, logline:"looking at posting count [\(messages.count)] messages")
        
        for message:Message in messages  {
            
           

            

            var apiEndpoint:String = Constants().kAPI_MESSAGE;
            apiEndpoint.appendContentsOf("add/");
            
            apiEndpoint.appendContentsOf(message.userId);
            
            if(message.userId.isEmpty) {
                let tempUUID:NSUUID = NSUUID();
                apiEndpoint.appendContentsOf(tempUUID.UUIDString);
                message.userId = tempUUID.UUIDString;
            }
            
             Logging.debug(className, methodName: funcName, logline:"message endpoint (\(apiEndpoint))")
            
            let json =  message.asJSON();
            
            Logging.debug(className, methodName: funcName, logline:"message format\n\n \(jsonToString(json))\n\n")
 
            Alamofire.request(.POST, apiEndpoint, parameters: message.asJSON(), encoding: .JSON)
                .response { (request, response, data, error) -> Void in
                    
                    //printDebug(response)
                    
                    Logging.debug(self.className, methodName: funcName, logline:"found status code \(response?.statusCode)")
                    
                    if response?.statusCode == 200 {
                        Logging.debug(self.className, methodName: funcName, logline:"success with status code \(response?.statusCode)")
                        self.messaging.deleteMessage(message);
                        
                    }
                    if response?.statusCode != 200 {
                        Logging.debug(self.className, methodName: funcName, logline:"failure with status code \(response?.statusCode)")
                        
                    }
 
            }
 
            Logging.debug(self.className, methodName: funcName, logline:"message identifier: \(message.messageId)");

            
        
        }//loop incoming messages
            
 
    }
    

    
    
    
}