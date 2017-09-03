//
//  MessageCollectionViewCell.swift
//  Rippl
//
//  Created by mike hargrove on 1/15/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    var message : Message!
    var msgView : MessageDisplayView!
    
    func setMessage(message: Message, viewOnly: Bool)  {
        msgView  = MessageDisplayView(msg: message)
        msgView.setBorderInclude(false);
        self.addSubview(msgView)
        //addConstraints(applyConstraintsToMessageView(msgView))
    }
    
    
    override func layoutSubviews()  {
        addConstraints(applyConstraintsToMessageView(msgView))
        msgView.setBorderInclude(false);
    }

    func applyConstraintsToMessageView(mv: MessageDisplayView) -> Array<NSLayoutConstraint>  {
        
        var constraintsArray = Array<NSLayoutConstraint>()
        
        mv.translatesAutoresizingMaskIntoConstraints = false;
        
        let constX = NSLayoutConstraint(item: mv, attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier : 1, constant : 0)
        
        let constY = NSLayoutConstraint(item: mv, attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier : 1, constant : 0)
        
        //self.frame.width
        
        let constW = NSLayoutConstraint(item: mv, attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        
        
        let constH = NSLayoutConstraint(item: mv, attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant:0)
        
        
        constraintsArray.append(constX);
        constraintsArray.append(constY);
        constraintsArray.append(constW);
        constraintsArray.append(constH);
        
        
        return constraintsArray
        
    }


    
}
