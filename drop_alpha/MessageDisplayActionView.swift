//
//  MessageView.swift
//  Rippl
//
//  Created by mike hargrove on 1/2/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import UIKit

class MessageDisplayActionView: UIView {
    
    
    let className :String = "MessageDisplayActionView";
    
    var isViewOnly : Bool = false
    
    var message : Message!
    
    var messageDisplay : MessageDisplayView!
    var util = Utility();
    

    
    
    var recognizer:UIPanGestureRecognizer!
    
    let ACTION_MARGIN =  120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
    let SCALE_STRENGTH = 4 //%%% how quickly the card shrinks. Higher = slower shrinking
    let SCALE_MAX = 0.93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
    let ROTATION_MAX = 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
    let ROTATION_STRENGTH = 320 //%%% strength of rotation. Higher = weaker rotation
    let ROTATION_ANGLE = M_PI/8 //%%% Higher = stronger rotation angle
    
    var originalPoint:CGPoint!

    override func layoutSubviews()  {
        //let width = self.frame.width;
        //let height = message.getMessageHeight(width) * 2;
        
        //println("layoutSubviews(): message \(message.message)")
        //println("layoutSubviews(): message height \(height)");
        //println("layoutSubviews(): message width \(width)");
        
        let messageViewConstX = NSLayoutConstraint(item: messageDisplay, attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier : 1, constant : 0)
        self.addConstraint(messageViewConstX);
        
        let messageViewConstY = NSLayoutConstraint(item: messageDisplay, attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier : 1, constant : 0)
        self.addConstraint(messageViewConstY);
        
        
        let constWidth = NSLayoutConstraint(item: messageDisplay, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0)
        addConstraint(constWidth)
        
        let constHeight = NSLayoutConstraint(item: messageDisplay, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0)
        //let constHeight = NSLayoutConstraint(item: messageDisplay, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        addConstraint(constHeight)
        
        
    }
    
    
    func setup() {
        
        let funcName : String = "setup()";
        
        Logging.debug(className, methodName: funcName, logline:"start")
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.whiteColor()
        messageDisplay = MessageDisplayView(msg: message)
        
        if(!isViewOnly)  {
            Logging.debug(className, methodName: funcName, logline:"adding pan gestures")
            recognizer = UIPanGestureRecognizer(target: self, action: #selector(MessageDisplayActionView.beingDragged))
            messageDisplay.addGestureRecognizer(recognizer)
            
        }
        
 
        self.addSubview(messageDisplay)
    }
    
    
    func beingDragged()  {

        
        let funcName : String = "beingDragged()";
        
        
        let messaging:Messaging = Messaging();
        
        let boundedWidth = self.frame.width/8;

        
        switch recognizer.state  {
            
        case .Began:
            //print("began")
            originalPoint = self.center
        case .Ended:
            let delta = recognizer.translationInView(self);
            
            //print("center x is \(center.x)")
            //print("delta x is \(delta.x)")
            //print("frame forth width is \(boundedWidth)")
            //print("right x is \(center.x + (boundedWidth))")
            //print("left x is \(center.x - (boundedWidth))")
            
            Logging.info(className, methodName: funcName, logline:"swipe message uuid \(message.messageId)")
            
            if(center.x + delta.x > center.x + (boundedWidth))  {
                //to the right
                
                Logging.info(className, methodName: funcName, logline:"swipe RIGHT uuid \(message.messageId)")
                messaging.updateMessageDisposition(message.messageId, disposition: Constants().kDISPOSITION_LIKE)
                let notification = NSNotification(name:"messageSwipe", object:self, userInfo:  nil);
                NSNotificationCenter.defaultCenter().postNotification(notification);
                //let messageKey: [String:String] = ["message_identifier": message.messageId, "disposition": String(Constants().kDISPOSITION_LIKE)];
                //let notification = NSNotification(name:"messageSwipe", object:self, userInfo:  messageKey);

                removeFromSuperview()
            }
            else if(center.x + delta.x < center.x - (boundedWidth))  {
                //to the left
                
                Logging.info(className, methodName: funcName, logline:"swipe LEFT uuid \(message.messageId)")
                messaging.updateMessageDisposition(message.messageId, disposition: Constants().kDISPOSITION_DISLIKE)
                let notification = NSNotification(name:"messageSwipe", object:self, userInfo:  nil);
                NSNotificationCenter.defaultCenter().postNotification(notification);
                
                //let messageKey: [String:String] = ["message_identifier": message.messageId, "disposition": String(Constants().kDISPOSITION_DISLIKE)];
                //let notification = NSNotification(name:"messageSwipe", object:self, userInfo:  messageKey);
                //NSNotificationCenter.defaultCenter().postNotification(notification);
                removeFromSuperview()
            }
            else {
                messageDisplay.backgroundColor = util.defaultColorBlue();
            }
            break

        case .Changed:
            
            let delta = recognizer.translationInView(self);
            
            var percentage:CGFloat = 1.0;
            //Logging.info(className, methodName: funcName, logline:"percentage : \(percentage) boundedWidth \(boundedWidth) delta \(abs(delta.x))")
            if(boundedWidth > abs(delta.x))  {
                percentage = 1 - (abs(delta.x) / boundedWidth);
            }
            else {
                percentage = 1.0;
            }
             Logging.debug(className, methodName: funcName, logline:"percentage : \(percentage) boundedWidth \(boundedWidth) delta \(abs(delta.x))")
             
 
            if(center.x + delta.x > center.x + (boundedWidth))  {
                messageDisplay.backgroundColor = util.defaultColorGreen();
                
                //messageDisplay.alpha = percentage
            }
            else if(center.x + delta.x < center.x - (boundedWidth))  {
                messageDisplay.backgroundColor = util.defaultColorRed();
                //messageDisplay.alpha = percentage
            }
            else {
                messageDisplay.alpha = 1.0
                messageDisplay.backgroundColor = util.defaultColorBlue();
            }
            
            break
            
        default:
            //    println("default break")
            break
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    convenience init()  {
        self.init(frame: CGRectZero)
    }
    
    convenience init(msg : Message, viewOnly: Bool)  {
        self.init();
        self.message = msg
        self.isViewOnly = viewOnly
        setup();
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
}
