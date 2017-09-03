//
//  HomeViewControllerCards.swift
//  Rippl
//
//  Created by mike hargrove on 8/3/16.
//  Copyright © 2016 mike hargrove. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

extension HomeViewController  {
    
    
    func loadMessage()  {
        
        //collectionView?.reloadData();
        
        //return;
        
        let funcName = "loadMessage";
        
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let mv = messageView  {
            Logging.info(className, methodName: funcName, logline:"removing message view");
            mv.removeFromSuperview();
        }
        
        
        
        Logging.info(className, methodName: funcName, logline:"loadMessage messages.isEmpty  \(recievedMessages.isEmpty)")
        
        if(!recievedMessages.isEmpty)  {
            
            currentMessage = recievedMessages.first;
            
            messageView  = MessageDisplayActionView(msg: currentMessage, viewOnly: false);
            messageView.backgroundColor = UIColor.whiteColor();
            view.addSubview(messageView);
            
            Logging.info(className, methodName: funcName, logline:"adding message view");
            
            messageView.translatesAutoresizingMaskIntoConstraints = false;
            
            //let width = view.frame.width;
            //let height = currentMessage.getMessageHeight(width);
            
            //Logging.debug(className, methodName: funcName, logline:"width of message is [\(width)] and height is [\(height)]");
            
            let messageViewConstW = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.Width,
                                                       relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
            view.addConstraint(messageViewConstW);
            
            let messageViewTop = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.Top,
                                                    relatedBy: NSLayoutRelation.Equal, toItem: self.mapView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            view.addConstraint(messageViewTop);
            
            let messageViewBottom = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.Bottom,
                                                       relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier: 1, constant: 0)
            view.addConstraint(messageViewBottom);
            
            let messageViewConstX = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.CenterX,
                                                       relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier : 1, constant : 0)
            view.addConstraint(messageViewConstX);
            
            /*
             var messageViewConstW = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.Width,
             relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: width)
             view.addConstraint(messageViewConstW);
             
             var messageViewHeight = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.Height,
             relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier : 1, constant : height)
             view.addConstraint(messageViewHeight);
             */
            /*
             
             
             let messageViewconstY = NSLayoutConstraint(item: messageView, attribute: NSLayoutAttribute.CenterY,
             relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier : 1, constant : 0)
             view.addConstraint(messageViewconstY);
             */
        } // not is empty
        
        
    }
    
    func initilizeMessages()  {
        
        let funcName = "initilizeMessages";
        Logging.debug(className, methodName: funcName, logline:"Home View Controller : initialize Messages: queuedCount \(recievedMessages.count)")
        
        if(recievedMessages.count == 0 || recievedMessages.count < 3)  {
            
            let messages:[Message] = messaging.getMessagesInDisposition(Constants().kDISPOSITION_RECIEVED);
            recievedMessages.removeAll();
            collectionView?.reloadData();
            for message:Message in messages  {
                if(!messagePreviouslyLoaded(message))  {
                    recievedMessages.append(message);
                }
            }
            collectionView?.reloadData();
            
        }
        
        
    }
    
    
    func messagePreviouslyLoaded(message:Message) -> Bool {
        
        let funcName : String = "messagePreviouslyLoaded(message:Message)";
        
        let messageIndentifier:String = message.messageId;
        Logging.debug(className, methodName: funcName, logline:"\(messageIndentifier)  queueSize \(recievedMessages.count)")
        
        for messageInQueue in recievedMessages  {
            Logging.debug(className, methodName: funcName, logline:" [\(messageInQueue.messageId)] ")
            
            //Logging.info(className, methodName: funcName, logline:" \(msg.messageId)")
            //Logging.info(className, methodName: funcName, logline:" \(message.messageId)\n\n ")
            
            if messageInQueue.messageId == messageIndentifier  {
                Logging.debug(className, methodName: funcName, logline:"EQUAL")
                return true;
            }
            
        }
        
        Logging.debug(className, methodName: funcName, logline:"No Match Found")
        
        return false;
        
    }
    
    func printPreviouslyLoaded() {
        
        let funcName : String = "printPreviouslyLoaded()"; //"messagePreviouslyLoaded(message:Message)";
        
        for message in recievedMessages  {
            Logging.debug(className, methodName: funcName, logline:" [\(message.messageId)] ")
        }
        
        
    }
    
    func discard() {
        
        let funcName = "discard"
        
        let messageKey: [String:String] = ["message_identifier": "", "disposition": "-1"];
        let notification = NSNotification(name:"messageSwipe", object: self, userInfo:messageKey);
        NSNotificationCenter.defaultCenter().postNotification(notification);
        
        Logging.log(className, methodName: funcName, logline:"discard")
        //self.performSegueWithIdentifier("goPost", sender: self)
    }
    
    func keep() {
        let funcName = "keep"
        
        let messageKey: [String:String] = ["message_identifier": "", "disposition": "1"];
        let notification = NSNotification(name:"messageSwipe", object: self, userInfo: messageKey);
        NSNotificationCenter.defaultCenter().postNotification(notification);
        
        Logging.debug(className, methodName: funcName, logline:"keep")
    }
    
    
    func disposition(notification:NSNotification)  {
        
        let funcName = "disposition(notification:NSNotification)";
        
        Logging.info(className, methodName: funcName, logline:"start");
        
        
        initilizeMessages();
        loadMessage();
        
    }
    

    
}