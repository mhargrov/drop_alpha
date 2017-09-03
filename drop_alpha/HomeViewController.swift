//
//  ViewController.swift
//  Rippl
//
//  Created by mike hargrove on 11/19/14.
//  Copyright (c) 2014 mike hargrove. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class HomeViewController: RipplBaseViewController { //, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let className = "HomeViewController";

    
    var recievedMessages:[Message] = [];
    
    var collectionView : UICollectionView?
    var mapView:MKMapView!;
    
    var widthOfCollection:CGFloat = 0
    
    
    var replyButton : UIButton!
    var reportButton : UIButton!
    
    var util = Utility();
    
    
    var currentMessage:Message!;
    var messageView : MessageDisplayActionView!;

    let messaging:Messaging = Messaging();
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let funcName = "vieDidLoad()";
        
        Logging.info(className, methodName: funcName, logline:" loaded")

        
        mapView = MKMapView();
        mapView.frame = CGRectMake(10, 20, view.frame.size.width-20, view.frame.size.width-20)
        mapView.mapType = .Standard
        mapView.translatesAutoresizingMaskIntoConstraints = false;
        mapView.delegate = self;
        mapView.showsUserLocation = true;
        
        mapView.scrollEnabled = false;
        mapView.zoomEnabled = false;
        
        view.addSubview(mapView);
        
        let mapTop = NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier:1, constant: 0)
        view.addConstraint(mapTop);
        let mapWidth =  NSLayoutConstraint(item: mapView, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier:1, constant: 0)
        view.addConstraint(mapWidth);
        let mapHeight =  NSLayoutConstraint(item: mapView, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier:1, constant: 0)
        view.addConstraint(mapHeight);
        
        Logging.info(className, methodName: funcName, logline:" map completed")
        
        
        currentViewController = Navigator().LOCATION_HOME
        
        view.backgroundColor = UIColor.whiteColor();
        
        if(Maintain.isClear())  {
            let messaging:Messaging = Messaging();
            let messages:[Message] = messaging.getMessages();
            for message:Message in messages  {
                messaging.deleteMessage(message);
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.updatedMessages(_:)), name: "messagesRecieved", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.disposition(_:)), name: "messageSwipe", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.updateLocation), name: "updateLocation", object: nil)

        
        
        Logging.info(className, methodName: funcName, logline:" notifications")

        initilizeMessages();
        
        Logging.info(className, methodName: funcName, logline:" initialized")

        loadMessage();
        
        Logging.info(className, methodName: funcName, logline:" load")

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    

    

    

    
    
    



    
    

    
    
    func updatedMessages(notification: NSNotification)  {
        //let funcName = "updatedMessages";
        //Logging.log(className, methodName: funcName, logline:"updatedMessages(notification: NSNotification)");
        initilizeMessages()
        loadMessage();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
       

               
    }



}

