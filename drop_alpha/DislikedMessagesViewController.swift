//
//  PersistedMessagesViewController.swift
//  Rippl
//
//  Created by mike hargrove on 1/11/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import UIKit

class DiscardedMessagesViewController: RipplBaseViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    var messages : [Message]!;
    
    var collectionView : UICollectionView?
    var widthOfCollection : CGFloat = 0.0;
    
    let util:Utility = Utility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //currentViewController = Navigator().LOCATION_DISLIKED
        
        print("Disliked View Controller")

        
        /*
        screenLeftEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleScreenLeftEdge");
        screenLeftEdgeRecognizer.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(screenLeftEdgeRecognizer)
        
        screenRightEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleScreenRightEdge");
        screenRightEdgeRecognizer.edges = UIRectEdge.Right
        self.view.addGestureRecognizer(screenRightEdgeRecognizer)
*/


        let m : Message = Message();
        m.content = "HEllo World this is a longer message to see what happens in the case of a longer mesaage to see how the heigth works"
        m.userId = "mhargrove"
        
        

        
        
        messages = [Message]()
        messages.append(m)

        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        layout.sectionInset = UIEdgeInsets(top:1, left:10, bottom:0, right:10)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
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
        self.view.addSubview(collectionView!);        // Do any additional setup after loading the view.
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
        
        let util:Utility = Utility()
        
        let width : CGFloat = cell.frame.size.width
        var cellHeight : CGFloat = util.heightForView(msg.content, font: util.defaultFont(), width: width);
        
        if(cellHeight == 0) {
            cellHeight = 200.0;
            print("cell Height has been defaulted")
        }
        else {
            print("cell height [\(cellHeight)]")
        }
        
        if(cellHeight < 50)  {
            cellHeight = 50
        }
        
        let rect : CGRect = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: cellHeight)
        
        cell.frame = rect;
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 0.25;
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        let msg = messages[indexPath.row]
        var cellHeight : CGFloat = util.heightForView(msg.content, font: util.defaultFont(), width: widthOfCollection);
        
        if(cellHeight < 50)  {
            cellHeight = 50
        }
        
        return CGSizeMake(widthOfCollection, cellHeight + 20)
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
