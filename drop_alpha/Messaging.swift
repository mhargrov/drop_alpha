//
//  Messaging.swift
//  Rippl
//
//  Created by mike hargrove on 6/13/15.
//  Copyright © 2015 mike hargrove. All rights reserved.
//

import Foundation
import CoreData


// MARK : Messaging Syncronization

class Messaging {
    
    lazy var persistence = Persistence()
    
    let className = "Messaging";
    
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    func deleteMessage(message:Message)  {
        
        let funcName = "deleteMessage(message:Message)";
        
        do {
            
            Logging.debug(self.className, methodName: funcName, logline:"deleting message \(message.messageId)")
            let fetchRequestCompleted = NSFetchRequest(entityName: "MessageQueue");
            let predicateMessage = NSPredicate(format: "messageIdentifier = %@", message.messageId);
            fetchRequestCompleted.predicate = predicateMessage;
            let messagesFound = try persistence.context!.executeFetchRequest(fetchRequestCompleted) as! [MessageQueue!]
            for mqw:MessageQueue in messagesFound  {
                persistence.context!.deleteObject(mqw);
            }
            persistence.saveContext();
            
        }
        catch let error as NSError {
            Logging.error(self.className, methodName: funcName, logline:"error deleting message \(message.messageId) error: \(error.description)")

        }
        
        
        
    }
    
    func deleteLocation(location:Location)  {
        
        
        let funcName = "deleteLocation(location:Location)";
        
        //Logging.log(self.className, methodName: funcName, logline:"location marked count \(locationsMarked.count)");
        
        //for location:Location in locationsMarked  {
        Logging.log(className, methodName: funcName, logline:"locationIdentifier [\(location.locationIdentifier)] latitude [\(location.latitude)] longitude [\(location.longitude)] markdatetime [\(location.markDateTime)]")
        
        let fetchRequestCompleted = NSFetchRequest(entityName: "LocationQueue");
        //let predicateLocation = NSPredicate(format: "latitude =%d and longitude =%d ", location.latitude, location.longitude);
        //let predicateLocation = NSPredicate(format: "markDateTime == %@ ", location.markDateTime);
        let predicateLocation = NSPredicate(format: "locationIdentifier = %@ ", location.locationIdentifier);
        
        //Logging.log(self.className, methodName: funcName, logline:"predicateFormat \(predicateLocation.predicateFormat)")
        fetchRequestCompleted.predicate = predicateLocation;
        
        
        
        do {
            let locationsFound = try persistence.context!.executeFetchRequest(fetchRequestCompleted) as! [LocationQueue!]
            Logging.debug(self.className, methodName: funcName, logline:"matches sent locations at [\(locationsFound.count)]")
            
            
            for loc:LocationQueue in locationsFound  {
                Logging.debug(self.className, methodName: funcName, logline:"deleting location")
                persistence.context!.deleteObject(loc);
                
            }
            
            Logging.debug(className, methodName: funcName, logline:"\n\n")
            
        }catch {
            Logging.debug(className, methodName: funcName, logline:"error removing location")
        }
        
        //} //loop locations
        
        
        persistence.saveContext();
        
        
    }
    
    
    func countMessage(message:Message) -> Int {
        
        
        let funcName = "countMessages(message:Message)";
        
        Logging.debug(self.className, methodName: funcName, logline:"counting for message id  \(message.messageId)");
        
        let fetchRequestCompleted = NSFetchRequest(entityName: "MessageQueue");
        let predicateMessage = NSPredicate(format: "messageIdentifier = %@", message.messageId);
        
        Logging.debug(self.className, methodName: funcName, logline:"predicateFormat: [\(predicateMessage.predicateFormat)]")
        fetchRequestCompleted.predicate = predicateMessage;
        
        do {
            let messagesFound = try persistence.context!.executeFetchRequest(fetchRequestCompleted) as! [MessageQueue!]
            
            Logging.debug(self.className, methodName: funcName, logline:"matches messages [\(messagesFound.count)]")
            return messagesFound.count;
            
        } catch {
            Logging.error(className, methodName: funcName, logline:"error counting message")
        }
        
        Logging.debug(self.className, methodName: funcName, logline:"\n\n");
        
        return 0;
        
        //persistence.saveContext();
        
        
    }
    
    
    func getMessage(messageId:String) -> Message {
        
        
        let funcName = "getMessage(messageId:String)";
        
        let message : Message = Message();
        
        Logging.debug(self.className, methodName: funcName, logline:"counting for message id  \(messageId)");
        
        let fetchRequestCompleted = NSFetchRequest(entityName: "MessageQueue");
        let predicateMessage = NSPredicate(format: "messageIdentifier = %@", messageId);
        
        Logging.info(self.className, methodName: funcName, logline:"predicateFormat: [\(predicateMessage.predicateFormat)]")
        fetchRequestCompleted.predicate = predicateMessage;
        
        do {
            let messagesFound = try persistence.context!.executeFetchRequest(fetchRequestCompleted) as! [MessageQueue!]
            
            Logging.info(self.className, methodName: funcName, logline:"matches messages [\(messagesFound.count)]")
            let messageQueue:MessageQueue = messagesFound.first!;
            message.fromMessageQueue(messageQueue);
            
        } catch {
            Logging.error(className, methodName: funcName, logline:"error counting message")
        }
        
        Logging.info(self.className, methodName: funcName, logline:"\n\n");
        
        return message;
        
    }
    
    func getMessages() -> [Message] {
        
        
        let funcName = "getMessagesInReceivedDisposition()";
        
        var messages : [Message] = [];
        
        
        let fetchRequest = NSFetchRequest(entityName: "MessageQueue")
        let sortDescriptor = NSSortDescriptor(key: "postDateTime", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //let predicate = NSPredicate(format: "disposition == %@", String(Constants().kDISPOSITION_RECIEVED))
        //fetchRequest.predicate = predicate
        
        do {
            
            let persistedMessages = try persistence.context!.executeFetchRequest(fetchRequest) as! [ MessageQueue!]
            if(persistedMessages.count > 0) {
                Logging.debug(className, methodName: funcName, logline:" persisted message count  [\(persistedMessages.count)] ")
                for pmessage:MessageQueue! in persistedMessages  {
                    
                    let message:Message = Message();
                    message.fromMessageQueue(pmessage);
                    messages.insert(message, atIndex: 0);
                    
                } //loop messages
                
                Logging.info(className, methodName: funcName, logline:" message count in recieved status \(messages.count) ");
                
            } // count > 0
            
            
        }
        catch let error as NSError {
            Logging.error(className, methodName: funcName, logline:"\(error.localizedDescription)")
        }
        
        return messages;
        
    }
    
    
    func getMessagesInDisposition(disposition:Int) -> [Message] {
        
        
        let funcName = "getMessagesInReceivedDisposition()";
        
        var messages : [Message] = [];
        
        
        let fetchRequest = NSFetchRequest(entityName: "MessageQueue")
        let sortDescriptor = NSSortDescriptor(key: "postDateTime", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "disposition == %@", String(disposition))
        fetchRequest.predicate = predicate
        
        do {
            
            let persistedMessages = try persistence.context!.executeFetchRequest(fetchRequest) as! [ MessageQueue!]
            if(persistedMessages.count > 0) {
                Logging.debug(className, methodName: funcName, logline:" persisted message count  [\(persistedMessages.count)] ")
                for pmessage:MessageQueue! in persistedMessages  {
                    
                    let message:Message = Message();
                    message.fromMessageQueue(pmessage);
                    messages.insert(message, atIndex: 0);
       
                } //loop messages
                
                Logging.info(className, methodName: funcName, logline:" message count in recieved status \(messages.count) ");
                
            } // count > 0
            
            
        }
        catch let error as NSError {
            Logging.error(className, methodName: funcName, logline:"\(error.localizedDescription)")
        }
        
        return messages;
        
    }
    
    
    func updateMessageDisposition(messageId:String,disposition:Int)  {
        
        
        let funcName = "updateMessageDisposition(messageId:String,disposition:Int)";
        
        
        Logging.debug(self.className, methodName: funcName, logline:"counting for message id  \(messageId)");
        
        let fetchRequestCompleted = NSFetchRequest(entityName: "MessageQueue");
        let predicateMessage = NSPredicate(format: "messageIdentifier = %@", messageId);
        
        Logging.info(self.className, methodName: funcName, logline:"predicateFormat: [\(predicateMessage.predicateFormat)]")
        fetchRequestCompleted.predicate = predicateMessage;
        
        do {
            let messagesFound = try persistence.context!.executeFetchRequest(fetchRequestCompleted) as! [MessageQueue!]
            
            Logging.info(self.className, methodName: funcName, logline:"matches messages [\(messagesFound.count)]")
            for messageQueue:MessageQueue in messagesFound  {
                messageQueue.disposition = disposition;
            }
            
            persistence.saveContext();
            
            
            
        } catch {
            Logging.error(className, methodName: funcName, logline:"error counting message")
        }
        
        Logging.info(self.className, methodName: funcName, logline:"\n\n");
        
        //return returnMessage;
        
    }
    
    func updateLocationPlacemark(locationId:String,placemark:String)  {
        
        
        let funcName = "updateLocationDisposition(locationId:String,description:String,disposition:Int))";
        
        
        Logging.info(self.className, methodName: funcName, logline:"counting for location id  \(locationId)");
        
        let fetchRequestCompleted = NSFetchRequest(entityName: "LocationQueue");
        let predicateMessage = NSPredicate(format: "locationIdentifier = %@", locationId);
        
        Logging.info(self.className, methodName: funcName, logline:"predicateFormat: [\(predicateMessage.predicateFormat)]")
        fetchRequestCompleted.predicate = predicateMessage;
        
        do {
            let locationsFound = try persistence.context!.executeFetchRequest(fetchRequestCompleted) as! [LocationQueue!]
            
            Logging.info(self.className, methodName: funcName, logline:"matches locations [\(locationsFound.count)]")
            for locationQueue:LocationQueue in locationsFound  {
                locationQueue.disposition = Constants().kDISPOSITION_UNPOSTED;
                locationQueue.placemark = placemark;
            }
            
            persistence.saveContext();
            
            
            
        } catch {
            Logging.error(className, methodName: funcName, logline:"error counting message")
        }
        
        Logging.info(self.className, methodName: funcName, logline:"\n\n");
        
        //return returnMessage;
        
    }
    
    func getLocations() -> [Location] {
        
        let funcName = "getLocations()()";
        
        var locations : [Location] = [];
        
        
        let fetchRequest = NSFetchRequest(entityName: "LocationQueue")
        let sortDescriptor = NSSortDescriptor(key: "markDateTime", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //let predicate = NSPredicate(format: "disposition == %@", String(Constants().kDISPOSITION_RECIEVED))
        //fetchRequest.predicate = predicate
        
        do {
            
            let persistedLocations = try persistence.context!.executeFetchRequest(fetchRequest) as! [LocationQueue!]
            if(persistedLocations.count > 0) {
                Logging.debug(className, methodName: funcName, logline:" persisted location count  [\(persistedLocations.count)] ")
                for persistedLocation:LocationQueue! in persistedLocations  {
                    
                    let location:Location = Location();
                    location.latitude = Double(persistedLocation.latitude)
                    location.longitude = Double(persistedLocation.longitude)
                    
                    locations.insert(location, atIndex: 0);
                    
                } //loop messages
                
                Logging.info(className, methodName: funcName, logline:" message count in recieved status \(locations.count) ");
                
            } // count > 0
            
            
        }
        catch let error as NSError {
            Logging.error(className, methodName: funcName, logline:"\(error.localizedDescription)")
        }
        
        return locations;
        
        
    }
    
    
    //var lastLongitude : Double = 0;
    //var lastLatitude : Double = 0;
    var lastMessageCheckDateTime:String = "";
    
    
    func markLocations(currentLocation: Location)  {
        
        let funcName = "markLocations()";
        
        Logging.debug(className, methodName: funcName, logline:"markLocations(notification:NSNotification)");

        
        let fetchRequest = NSFetchRequest(entityName: "LocationQueue")
        let sortDescriptor = NSSortDescriptor(key: "markDateTime", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicatePlus = NSPredicate(format: "disposition = %@", "-1")
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = predicatePlus
        
        
        do {
            
            let communicate:Communicate = Communicate();

            
            let persistedLocations = try persistence.context!.executeFetchRequest(fetchRequest) as! [LocationQueue!]
            
            if(persistedLocations.count > 0)   {
                
                Logging.log(className, methodName: funcName, logline:"persistedLocations count \(persistedLocations.count)")
                
                var locationsToMark:[Location] = [];
                
                var locationCount = persistedLocations.count;
                
                while locationCount > 1 {
                    let locationQueue:LocationQueue! = persistedLocations.last;
                    locationsToMark.append(locationQueue.toLocation());
                    locationCount = locationCount - 1;
                }

                communicate.markLocation(persistence, locations: locationsToMark);
                
                
                
            }//locations to mark > 0
            else {
                
                //communicate.markLocation(persistence, locations: [currentLocation]);
            }
            
            
        }
        catch {
            Logging.error(className, methodName: funcName, logline:"error communicating");

        }
        
        
    }
    
    
    func dispositionMessages()  {
        
        //let funcName = "dispositionMessages()";
        
        //Logging.log(className, methodName: funcName, logline:"dispositionMessages(notification:NSNotification)");
        
        
        let username:String = self.prefs.objectForKey("UUID") as! String
        
        
        let fetchRequest = NSFetchRequest(entityName: "MessageQueue")
        let sortDescriptor = NSSortDescriptor(key: "postDateTime", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicatePlus = NSPredicate(format: "disposition == %@ OR disposition == %@ OR disposition == %@", "1", "-1", "-20")
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = predicatePlus
        
        
        do {
            
            let persistedMessages = try persistence.context!.executeFetchRequest(fetchRequest) as! [MessageQueue!]
            
            
            
            //Logging.log(className, methodName: funcName, logline:"dispositioned message count \(persistedMessages.count)")
            if(persistedMessages.count > 0)  {
                
                
                var messagesToDisposition:[Message] = [];
                for messageQueue:MessageQueue! in persistedMessages {
                    messagesToDisposition.append(messageQueue.toMessage());
                }
                
                let communicate:Communicate = Communicate();
                communicate.dispositionMessages(persistence, messages: messagesToDisposition, userIdentifier:username);
                
            }// count > 0
            persistence.saveContext();
            
        }  catch {
            //TODO
        }
        
        
    }
    
    
    func addMessage(message:Message, disposition:Int)  {
        
        let funcName = "addMessage(message:Message)";
        
        do {
        
            let messageQueueRow = NSEntityDescription.insertNewObjectForEntityForName("MessageQueue", inManagedObjectContext: persistence.context!) as! MessageQueue;
            messageQueueRow.message = message.content
            messageQueueRow.disposition = disposition
            messageQueueRow.latitude = message.latitude
            messageQueueRow.longitude = message.longitude
            messageQueueRow.messageIdentifier = message.messageId
            messageQueueRow.userIdentifier = message.userId
            messageQueueRow.postDateTime = message.createDate;
            
            Logging.debug(className, methodName: funcName, logline:"saving a message to the store");
            persistence.saveContext();
            
            Logging.debug(className, methodName: funcName, logline:"saved message \(message.messageId)");

        }
        //catch {
        //     Logging.log(className, methodName: funcName, logline:"error saving message");
        //}
        
        
    }
    
    func addLocation(location:Location)  {
        
        let funcName = "addLocation(location:Location)";
        
        do {
            
            let uuid:NSUUID = NSUUID();
            Logging.debug(className, methodName: funcName, logline:"new location");
            let locationQueueRow = NSEntityDescription.insertNewObjectForEntityForName("LocationQueue", inManagedObjectContext: persistence.context!) as! LocationQueue;
            locationQueueRow.locationIdentifier = uuid.UUIDString;
            locationQueueRow.longitude = location.longitude
            locationQueueRow.latitude = location.latitude
            locationQueueRow.course = location.course
            locationQueueRow.speed = location.speed
            locationQueueRow.markDateTime = NSDate()
            locationQueueRow.horizontalAccuracy = location.horizontalAccuracy
            locationQueueRow.userIdentifier = location.userIdentifier;
            locationQueueRow.disposition = -1;
            locationQueueRow.altitude = location.altitude
            Logging.info(className, methodName: funcName, logline:"saving a message to the store");
            persistence.saveContext();
            
            //Logging.debug(className, methodName: funcName, logline:"saved message \(message.messageId)");
            
        }
        //catch {
        //     Logging.log(className, methodName: funcName, logline:"error saving message");
        //}
        
        
    }
    
    func postMessage() -> [Message] {
        
        let funcName = "postMessage()";
        
        Logging.debug(className, methodName: funcName, logline:"postMessage start")
        
        var messagesToPost:[Message] = [];
        
        do {
            
            let fetchRequest = NSFetchRequest(entityName: "MessageQueue")
            let predicate = NSPredicate(format: "disposition == %@", String(Constants().kDISPOSITION_UNPOSTED))
            fetchRequest.predicate = predicate
            let messagesWaitingToPost = try persistence.context!.executeFetchRequest(fetchRequest) as! [MessageQueue!]
            Logging.debug(className, methodName: funcName, logline:"messagesWaitingToPost count \(messagesWaitingToPost.count)")
            
            
            for mqa:MessageQueue in messagesWaitingToPost  {
                messagesToPost.append(mqa.toMessage())
            }
            
            if(messagesToPost.count > 0)  {
                let communicate : Communicate = Communicate()
                communicate.postMessages(persistence, messages: messagesToPost)
                
            }

            
        }  catch {
            
        }
        
        return messagesToPost;
    }
    
    
    
    func messageCheck(lastLatitude:Double, lastLongitude:Double)  {
        
        let funcName = "messageCheck(lastLatitude:Double, lastLongitude:Double)";
        
        Logging.debug(className, methodName: funcName, logline:"latitude \(lastLatitude), longitude \(lastLongitude)")
        
        let username:String = self.prefs.objectForKey("UUID") as! String
        
        let location:Location! = Location();
        location.latitude = lastLongitude;
        location.longitude = lastLongitude;
        Logging.debug(className, methodName: funcName, logline:"userId \(username), latitude \(location.latitude), longitude \(location.longitude)")
        
        let communication:Communicate = Communicate();
        communication.messageCheck(persistence, userIdentifier: username, location: location, lastCheck: lastMessageCheckDateTime)
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // superset of OP's format
        lastMessageCheckDateTime = dateFormatter.stringFromDate(NSDate())
        
        
        
        
    }
    
}