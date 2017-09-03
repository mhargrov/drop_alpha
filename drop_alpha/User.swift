//
//  User.swift
//  Rippl
//
//  Created by mike hargrove on 11/22/14.
//  Copyright (c) 2014 mike hargrove. All rights reserved.
//

import UIKit

class User: NSObject {
   
    override init()  {
        username = ""
        password = ""
    }
    
    
    
    func getUsernameFromPreferences() -> String {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let uname:String = prefs.objectForKey("UUID") as? String  {
            return uname;
        }
        return ""
    }
    
    var username : String
    var password : String
    
    func formatLoginRequest() -> String  {
    
    var request : String = "";
    
    request += "{\n \"aoc\":\"user\",\n \"action\":\"login\",\n "
    request += " \"username\":\"\(username)\",\n \"password\":\"\(password)\"\n }"
    
    
    print(request)
    
    
    return request
    
    }
    
 
    func formatCreateAccountRequest() -> String  {
        
        var request : String = "";
        
        request += "{\n \"aoc\":\"user\",\n \"action\":\"create\",\n "
        request += " \"username\":\"\(username)\",\n \"password\":\"\(password)\"\n }"
        
        
        print(request)
        
        
        return request
        
    }
    
}
