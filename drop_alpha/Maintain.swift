//
//  Logging.swift
//  Rippl
//
//  Created by mike hargrove on 6/30/15.
//  Copyright © 2015 mike hargrove. All rights reserved.
//

import Foundation

enum MaintainLevel {
    case NONE, CLEAR
}




var MLEVEL:MaintainLevel = MaintainLevel.NONE;



class Maintain {
    
    
    class func isClear() -> Bool {
        return (MLEVEL == MaintainLevel.CLEAR);
    }
    
    
    class func setLevel(maintainLevel:MaintainLevel) {
        MLEVEL = maintainLevel;
    }
    
}