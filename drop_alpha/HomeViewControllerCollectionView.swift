//
//  File.swift
//  Rippl
//
//  Created by mike hargrove on 8/3/16.
//  Copyright © 2016 mike hargrove. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit


extension HomeViewController {
    
    
    /*
     let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout();
     layout.sectionInset = UIEdgeInsets(top:1, left:0, bottom:0, right:0)
     layout.minimumInteritemSpacing = 0
     layout.minimumLineSpacing = 0
     layout.scrollDirection = .Vertical
     
     widthOfCollection = (self.view.frame.width);
     //var margin = (self.view.frame.width - widthOfCollection) / 2;
     
     layout.itemSize = CGSize(width:widthOfCollection, height:self.view.frame.height)
     
     let rect:CGRect = CGRect(x: 0, y: 20, width: widthOfCollection, height: 20)
     */
    
    /*
     collectionView = UICollectionView(frame:rect, collectionViewLayout:layout)
     collectionView!.dataSource = self
     collectionView!.delegate = self
     collectionView!.registerClass(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
     collectionView!.backgroundColor = UIColor.whiteColor()
     view.addSubview(collectionView!);
     
     let collectionTop = NSLayoutConstraint(item: collectionView!, attribute: .Top, relatedBy: .Equal, toItem: mapView, attribute: .Bottom, multiplier:1, constant: 5)
     view.addConstraint(collectionTop);
     
     //let collectionBottom =  NSLayoutConstraint(item: collectionView!, attribute: .Bottom, relatedBy: .Equal, toItem: replyLeading, attribute: .Top, multiplier:1, constant: 0)
     //view.addConstraint(collectionBottom);
     
     //let collectionWidth =  NSLayoutConstraint(item: collectionView!, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier:1, constant: 0)
     //view.addConstraint(collectionWidth);
     */
    
    
    /*
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
     let funcName :String = "collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int)";
     
     Logging.debug(className, methodName: funcName, logline:"messages array count [\(recievedMessages.count)]")
     
     return recievedMessages.count;
     }
     
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
     
     let funcName : String = "collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)";
     
     let cell: MessageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MessageCollectionViewCell
     cell.backgroundColor = UIColor.whiteColor()
     let msg = recievedMessages[indexPath.row]
     
     Logging.debug(className, methodName: funcName, logline:" \(msg.asJSON())")
     
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
     
     let msg = recievedMessages[indexPath.row]
     var cellHeight : CGFloat = util.heightForView(msg.content, font: util.defaultFont(), width: widthOfCollection);
     
     if(cellHeight < 75)  {
     cellHeight = 75
     }
     
     return CGSizeMake(widthOfCollection, cellHeight + 4)
     }
     */
    
    /*
     replyButton = UIButton(type:.System)
     replyButton.setTitle("discard", forState: UIControlState.Normal)
     replyButton.addTarget(self, action: #selector(HomeViewController.discard), forControlEvents: .TouchUpInside)
     replyButton.translatesAutoresizingMaskIntoConstraints = false
     replyButton.backgroundColor = util.defaultColorBlue(); //util.defaultColorRed();
     replyButton.layer.cornerRadius = 0
     
     
     reportButton = UIButton(type:.System)
     reportButton.setTitle("keep", forState: UIControlState.Normal)
     reportButton.addTarget(self, action: #selector(HomeViewController.keep), forControlEvents: .TouchUpInside)
     reportButton.translatesAutoresizingMaskIntoConstraints = false
     reportButton.backgroundColor = util.defaultColorBlue(); //util.defaultColorGreen();
     reportButton.layer.cornerRadius = 0
     
     
     view.addSubview(replyButton)
     view.addSubview(reportButton)
     
     
     let replyHeight = NSLayoutConstraint(item: replyButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:1, constant: 40)
     view.addConstraint(replyHeight);
     
     let reportHeight = NSLayoutConstraint(item: reportButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier:1, constant: 40)
     view.addConstraint(reportHeight);
     
     let replyWidthToMessage =  NSLayoutConstraint(item: replyButton, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier:0.50, constant: 0)
     view.addConstraint(replyWidthToMessage);
     
     let reportWidthToMessage =  NSLayoutConstraint(item: reportButton, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier:0.50, constant: 0)
     view.addConstraint(reportWidthToMessage);
     
     
     let replyLeading =  NSLayoutConstraint(item: replyButton, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier:1, constant: 0)
     view.addConstraint(replyLeading);
     
     let reportTrailing =  NSLayoutConstraint(item: reportButton, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier:1, constant: 0)
     view.addConstraint(reportTrailing);
     
     let reportBottom =  NSLayoutConstraint(item: reportButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier:1, constant: 0)
     view.addConstraint(reportBottom);
     
     let replyBottom =  NSLayoutConstraint(item: replyButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.bottomLayoutGuide, attribute: .Top, multiplier:1, constant: 0)
     view.addConstraint(replyBottom);
     
     */
    
}