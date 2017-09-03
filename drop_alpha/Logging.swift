//
//  Logging.swift
//  Rippl
//
//  Created by mike hargrove on 6/30/15.
//  Copyright © 2015 mike hargrove. All rights reserved.
//

import Foundation

enum LoggingLevel {
    case NONE, DEBUG, INFO, WARN, ERROR, CLEAR
}




var LEVEL:LoggingLevel = LoggingLevel.NONE;



class Logging {

    class func log(className: String, methodName:String, logline:String)  {
        print("LOG: className: \(className), methodName: \(methodName), log: \(logline)");
    }

    
    class func debug(className: String, methodName:String, logline:String)  {
        if(LEVEL == LoggingLevel.DEBUG)  {
           print("DEBUG: className: \(className), methodName: \(methodName), log: \(logline)");
        }
    }
    
    class func info(className: String, methodName:String, logline:String)  {
        if(LEVEL == LoggingLevel.DEBUG || LEVEL == LoggingLevel.INFO)     {
            print("INFO: className: \(className), methodName: \(methodName), log: \(logline)");
        }
    }
    
    class func warn(className: String, methodName:String, logline:String)  {
        if(LEVEL == LoggingLevel.DEBUG || LEVEL == LoggingLevel.INFO  || LEVEL == LoggingLevel.WARN)     {
            print("WARN: className: \(className), methodName: \(methodName), log: \(logline)");
        }
    }
    
    class func error(className: String, methodName:String, logline:String)  {
        if(LEVEL == LoggingLevel.DEBUG || LEVEL == LoggingLevel.INFO  || LEVEL == LoggingLevel.WARN  || LEVEL == LoggingLevel.ERROR)     {
            print("ERROR: className: \(className), methodName: \(methodName), log: \(logline)");
        }
    }
    
    class func isDebug() -> Bool {
        return (LEVEL == LoggingLevel.DEBUG);
    }
    
    class func isInfo() -> Bool {
        return (LEVEL == LoggingLevel.DEBUG || LEVEL == LoggingLevel.INFO);
    }
    
    class func setLevel(loggingLevel:LoggingLevel) {
        LEVEL = loggingLevel;
    }
    
}


