//
//  MessageDispositions.swift
//  Rippl
//
//  Created by mike hargrove on 7/5/15.
//  Copyright © 2015 mike hargrove. All rights reserved.
//

import Foundation


enum MessageDispositions:Int  {
    case LIKE = 1
    case DISLIKE = -1
    case UNDEFINED = 0
    case UNPOSTED = 20
}


//let kDISPOSITION_LIKE:Int = 1
//let kDISPOSITION_DISLIKE:Int = -1
//let kDISPOSITION_UNDEFINED:Int = 0
//let kDISPOSITION_UNPOSTED:Int = 20