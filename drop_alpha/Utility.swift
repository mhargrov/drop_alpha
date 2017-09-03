//
//  Utililty.swift
//  Rippl
//
//  Created by mike hargrove on 1/31/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import UIKit
import Foundation

class Utility  {
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
        
    }
    
    func defaultFont() -> UIFont {
        return UIFont.systemFontOfSize(16)
    }
    
    func defaultSmallFont() -> UIFont {
        return UIFont.systemFontOfSize(10)
    }
    
    
    func defaultOwnerLabelHeight()  -> CGFloat  {
        return 20;
    }
    //UIColor(red: 161.0/255.0, green:161.0/255.0, blue: 161.0/255.0, alpha:1).CGColor
    
    //green = r:163,g214,b189
    //red=r214,g163,b188
    
    func defaultColorGreen() -> UIColor  {
        return UIColor(red: 163.0/255.0, green:214.0/255.0, blue: 189.0/255.0, alpha:0.45)
    }
    
    func defaultColorRed() -> UIColor  {
        return UIColor(red: 214.0/255.0, green:163.0/255.0, blue: 188.0/255.0, alpha:0.45)
    }
    
    func defaultColorGrayWhite() -> UIColor  {
        return UIColor(red:242.0/255.0, green:242.0/255.0, blue:242.0/255.0, alpha:0.90);
    }
    
    func defaultColorBlue() -> UIColor  {
        return UIColor(red:163.0/255.0, green:175.0/255.0, blue:214.0/255.0, alpha:0.45);
    }
    
        
    
}