//
//  MessageDisplayView.swift
//  Rippl
//
//  Created by mike hargrove on 2/14/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import Foundation
import UIKit

class MessageDisplayView: UIView {

    
    var message : Message!
    
    var ownerLabel : UIInsetLabel!;
    var messageLabel : UIInsetLabel!;
    
    var includeBorder:Bool = true;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    convenience init()  {
        self.init(frame: CGRectZero)
    }
    
    convenience init(msg : Message)  {
        self.init();
        self.message = msg
        setup();
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     func requiresConstraintBasedLayout() -> Bool
    {
        return true;
    }
    
    func setBorderInclude(ib: Bool) {
        includeBorder = ib
        createBorder();
    }
    
    func createBorder()  {
        //print("createBorder")
        if(includeBorder)  {
            //print("creating a border")
            self.layer.borderColor = UIColor(red: 161.0/255.0, green:161.0/255.0, blue: 161.0/255.0, alpha:1).CGColor
            self.layer.borderWidth = 0.25;
            self.layer.cornerRadius = 3
        }
        else {
            //print("setting border to 0")
            self.layer.borderColor = UIColor.clearColor().CGColor
            self.layer.borderWidth = 0.0;
        }
    }
    
    override func layoutSubviews()  {
    
        
        //sender label
        
        let constTop = NSLayoutConstraint(item: ownerLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        addConstraint(constTop)
        
        let constHeight = NSLayoutConstraint(item: ownerLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        addConstraint(constHeight)
        
        let constWidth =  NSLayoutConstraint(item: ownerLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier:1, constant: 0)
        addConstraint(constWidth);
        
        let constLeading =  NSLayoutConstraint(item: ownerLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier:1, constant: 0)
        addConstraint(constLeading);
        
        //message view
        
        let mvTop = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: ownerLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        addConstraint(mvTop)
        
        let mvWidth =  NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: ownerLabel, attribute: NSLayoutAttribute.Width, multiplier:1, constant: 0)
        addConstraint(mvWidth);
        
        let mvBottom =  NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier:1, constant: 0)
        addConstraint(mvBottom);
        
        let messageViewconstX = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier : 1, constant : 0)
        self.addConstraint(messageViewconstX);
        
    }
    
    
    func setup() {
        
        //print("MessageDisplayView.setup")

        
       // self.backgroundColor = UIColor.redColor()
        createBorder()
        let util = Utility()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = util.defaultColorBlue();
        

        
        ownerLabel = UIInsetLabel()
        //label = UILabel(frame: CGRect(x:20, y:20, width:100, height:200));
        ownerLabel.text = "  \(message.userId)"
        ownerLabel.font = util.defaultSmallFont()
        ownerLabel.backgroundColor = UIColor.whiteColor();
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        messageLabel = UIInsetLabel();
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message.content
        messageLabel.font = util.defaultFont()
        messageLabel.backgroundColor = UIColor.whiteColor();  //UIColor(red:250.0/255.0, green:250.0/255.0, blue:250.0/255.0, alpha:1.0)
        messageLabel.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center


 
        
        
        self.addSubview(ownerLabel);
        self.addSubview(messageLabel)
        
        

        
    }
    

}