//
//  PersistedMessagesViewController.swift
//  Rippl
//
//  Created by mike hargrove on 1/11/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import UIKit
import CoreData

class LikedMessagesViewController: RipplBaseViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    var messages : [Message]!;
    
    let className = "LikedMessagesViewController";
    
        let persistence = (UIApplication.sharedApplication().delegate as! AppDelegate).persistence
    
    var collectionView : UICollectionView?
    var widthOfCollection:CGFloat = 0
    
    let util:Utility = Utility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        initilizeMessages();
        
        currentViewController = Navigator().LOCATION_LIKED
        
        print("Liked View Controller")
/*
        screenLeftEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleScreenLeftEdge");
        screenLeftEdgeRecognizer.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(screenLeftEdgeRecognizer)
        
        screenRightEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleScreenRightEdge");
        screenRightEdgeRecognizer.edges = UIRectEdge.Right
        self.view.addGestureRecognizer(screenRightEdgeRecognizer)
*/

        
        //messages = util.getTestMessages();

      
        self.view.backgroundColor = UIColor.whiteColor()

        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        layout.sectionInset = UIEdgeInsets(top:1, left:0, bottom:0, right:0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Vertical
        
        widthOfCollection = (self.view.frame.width);
        //var margin = (self.view.frame.width - widthOfCollection) / 2;
        
        layout.itemSize = CGSize(width:widthOfCollection, height:self.view.frame.height)
        
        let rect:CGRect = CGRect(x: 0, y: 20, width: widthOfCollection, height: self.view.frame.height)
        
        
        collectionView = UICollectionView(frame:rect, collectionViewLayout:layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!);
        
        
        // Do any additional setup after loading the view.
    }

    
    func initilizeMessages()  {
        
        let funcName = "initilizeMessages";
        Logging.log(className, methodName: funcName, logline:"Home View Controller : initialize Messages")
        messages = [];
        if(messages.count == 0)  {
            let fetchRequest = NSFetchRequest(entityName: "MessageQueue")
            let sortDescriptor = NSSortDescriptor(key: "postDateTime", ascending: true)
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            let predicate = NSPredicate(format: "disposition == %@", "0")
            
            // Set the predicate on the fetch request
            fetchRequest.predicate = predicate
            
            do {
                
                let persistedMessages = try persistence.context!.executeFetchRequest(fetchRequest) as! [ MessageQueue!]
                
                
                
                for pmessage:MessageQueue! in persistedMessages  {
                    let message:Message = Message();
                    
                    //var puiid = pmessage.valueForKey("messageIdentifier")!
                    
                    //var puuid: String = pmessage.messageIdentifier as String
                    
                    message.messageId  = pmessage.messageIdentifier! as String
                    message.content = pmessage.message! as String
                    message.disposition = pmessage.disposition.integerValue
                    message.createDate = pmessage.postDateTime;
                    
                   
                    message.latitude = pmessage.latitude.doubleValue
                    message.longitude = pmessage.longitude.doubleValue
                    
                   // message.location = location;
                    messages.insert(message,atIndex: 0);
                }
                
            }
            catch  {
                //print("error: \(error?.localizedDescription)")
                
            }
            
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("messages array count [\(messages.count)]")
        return messages.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MessageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MessageCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        let msg = messages[indexPath.row]
        cell.setMessage(msg, viewOnly: true)
        
     //   var util:Utility = Utility()
        
        let width : CGFloat = cell.frame.size.width
        var cellHeight : CGFloat = msg.getMessageHeight(width);
        
        
        if(cellHeight < 75)  {
            cellHeight = 75
        }
        
        let rect : CGRect = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: cellHeight)
        
        cell.frame = rect;
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 0.0;

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let msg = messages[indexPath.row]
        var cellHeight : CGFloat = util.heightForView(msg.content, font: util.defaultFont(), width: widthOfCollection);
        
        if(cellHeight < 75)  {
            cellHeight = 75
        }
        
        return CGSizeMake(widthOfCollection, cellHeight + 4)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/*
    var screenLeftEdgeRecognizer:UIScreenEdgePanGestureRecognizer!
    var screenRightEdgeRecognizer:UIScreenEdgePanGestureRecognizer!
    
    
    func handleScreenLeftEdge()  {
        println("handleScreenLeftEdge")
        
        switch screenLeftEdgeRecognizer.state
        {
        case UIGestureRecognizerState.Ended:
            
            let nav:Navigator = Navigator()
            let path : String = Navigator.transitionPath(nav.LOCATION_SWIPE, leftOrRight: nav.DIRECTION_LEFT)
            self.performSegueWithIdentifier(path, sender: self)
            break;
        default:
            break;
            
        }
        
        
    }
    
    func handleScreenRightEdge()  {
        println("handleScreenRightEdge")
        switch screenRightEdgeRecognizer.state
        {
        case UIGestureRecognizerState.Ended:
            
            let nav:Navigator = Navigator()
            let path : String = Navigator.transitionPath(nav.LOCATION_SWIPE, leftOrRight: nav.DIRECTION_RIGHT)
            self.performSegueWithIdentifier(path, sender: self)
            break;
        default:
            break;
            
        }
        
        
    }
*/    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
