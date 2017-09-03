//
//  RipplBaseViewController.swift
//  Rippl
//
//  Created by mike hargrove on 1/31/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//


import UIKit

class RipplBaseViewController: UIViewController {

    
    var currentViewController:Int = 0;
    
    var screenLeftEdgeRecognizer:UIScreenEdgePanGestureRecognizer!
    var screenRightEdgeRecognizer:UIScreenEdgePanGestureRecognizer!
        
    
    func handleScreenLeftEdge()  {
        //println("handleScreenLeftEdge")
        
        switch screenLeftEdgeRecognizer.state
        {
        case UIGestureRecognizerState.Ended:
            
            let nav:Navigator = Navigator()
            let path : Int = Navigator.transitionPath(currentViewController, leftOrRight: nav.DIRECTION_LEFT)
            self.tabBarController?.selectedIndex = path;
                        //self.performSegueWithIdentifier(path, sender: self)
            break;
        default:
            break;
            
        }
        
        
    }
    
    func handleScreenRightEdge()  {
        //println("handleScreenRightEdge")
        switch screenRightEdgeRecognizer.state
        {
        case UIGestureRecognizerState.Ended:
            
            let nav:Navigator = Navigator()
            let path : Int = Navigator.transitionPath(currentViewController, leftOrRight: nav.DIRECTION_LEFT)
            self.tabBarController?.selectedIndex = path;
            //self.performSegueWithIdentifier(path, sender: self)
            break;
        default:
            break;
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector:"userLocationChange:", name: "DefaultUserLocationChanged", object: nil)
        screenLeftEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(RipplBaseViewController.handleScreenLeftEdge));
        screenLeftEdgeRecognizer.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(screenLeftEdgeRecognizer)
        
        screenRightEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(RipplBaseViewController.handleScreenRightEdge));
        screenRightEdgeRecognizer.edges = UIRectEdge.Right
        self.view.addGestureRecognizer(screenRightEdgeRecognizer)
        
        
            }
    
}
