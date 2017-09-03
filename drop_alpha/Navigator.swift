//
//  Navigator.swift
//  Rippl
//
//  Created by mike hargrove on 1/20/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import Foundation


class Navigator  {
    

            
    let DIRECTION_LEFT:String = "left"
    let DIRECTION_RIGHT:String = "right"
    
    let LOCATION_HOME: Int = 0
    let LOCATION_POST: Int = 1
    let LOCATION_ACCOUNT: Int = 3
    let LOCATION_LIKED:Int = 2


//    let LOCATION_DISLIKED_MESSAGES:String = "sequeDisliked"
//    let LOCATION_SAVED: String = "goSaved"

    
    
    
    //let LOCATION_LIKED:String = "goLiked";
    
            
    
            
            
            

    
    class func transitionPath(currentLocation: Int, leftOrRight: String) -> Int  {
        
        var nextLocation : Int = 0;
        
        let nav:Navigator = Navigator()
        
        switch currentLocation
        {
            
        case nav.LOCATION_HOME :
            switch leftOrRight {
            case nav.DIRECTION_LEFT:
                nextLocation = nav.LOCATION_LIKED
            case nav.DIRECTION_RIGHT :
                nextLocation = nav.LOCATION_POST
            default:
                nextLocation = nav.LOCATION_HOME
            }
            
            
        case nav.LOCATION_POST :
            switch leftOrRight {
            case nav.DIRECTION_LEFT:
                nextLocation = nav.LOCATION_HOME
            case nav.DIRECTION_RIGHT :
                nextLocation = nav.LOCATION_ACCOUNT
            default:
                nextLocation = nav.LOCATION_HOME
            }
            
            
        case nav.LOCATION_ACCOUNT :
            switch leftOrRight {
            case nav.DIRECTION_LEFT:
                nextLocation = nav.LOCATION_POST
            case nav.DIRECTION_RIGHT :
                nextLocation = nav.LOCATION_LIKED
            default:
                nextLocation = nav.LOCATION_HOME
            }


        case nav.LOCATION_LIKED :
            switch leftOrRight {
            case nav.DIRECTION_LEFT:
                nextLocation = nav.LOCATION_ACCOUNT
            case nav.DIRECTION_RIGHT :
                nextLocation = nav.LOCATION_HOME
            default:
                nextLocation = nav.LOCATION_HOME
            }
            
/*
        case nav.LOCATION_SAVED :
            switch leftOrRight {
            case nav.DIRECTION_LEFT:
                nextLocation = nav.LOCATION_SWIPE
            case nav.DIRECTION_RIGHT :
                nextLocation = nav.LOCATION_SEARCH
            default:
                nextLocation = nav.LOCATION_SWIPE
            }
            


        case nav.LOCATION_LIKED_MESSAGES :
            switch leftOrRight {
            case nav.DIRECTION_LEFT:
                nextLocation = nav.LOCATION_SWIPE
            case nav.DIRECTION_RIGHT :
                nextLocation = nav.LOCATION_SAVED
            default:
                nextLocation = nav.LOCATION_SWIPE
            }
*/
        default:
            nextLocation = nav.LOCATION_HOME
        }
        
        return nextLocation
    }
    
    
    
    
}