//
//  AccountViewController.swift
//  Rippl
//
//  Created by mike hargrove on 1/31/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import UIKit

///

class AccountViewController: RipplBaseViewController {
    
    
    var loginButton:UIButton!
    var logoutButton:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        currentViewController = Navigator().LOCATION_ACCOUNT
        
        print("Account View Controller")
        
        loginButton = UIButton(type:.System)
        loginButton.setTitle("login", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: Selector("postMessage"), forControlEvents: .TouchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton = UIButton(type:.System) 
        logoutButton.setTitle("logout", forState: UIControlState.Normal)
        logoutButton.addTarget(self, action: Selector("fence"), forControlEvents: .TouchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(loginButton)
        self.view.addSubview(logoutButton)
        
        
        let constX = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view , attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(constX)
        
        let constY = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(constY)
        
        
        let loginHeight = NSLayoutConstraint(item: loginButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:1, constant: 30)
        view.addConstraint(loginHeight);
        
        let logoutHeight = NSLayoutConstraint(item: logoutButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:1, constant: 30)
        view.addConstraint(logoutHeight);
        
        
        let loginWidth = NSLayoutConstraint(item: loginButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier:0.8, constant: 0)
        view.addConstraint(loginWidth);
        
        let logoutWidth = NSLayoutConstraint(item: logoutButton, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier:0.8, constant: 0)
        view.addConstraint(logoutWidth);
        
        let logoutTop = NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal, toItem: loginButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(logoutTop)
        
        let logoutX = NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view , attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(logoutX)
        
        
    }
    
    
}
