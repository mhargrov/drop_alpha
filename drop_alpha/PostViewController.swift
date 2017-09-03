//
//  PostViewController.swift
//  Rippl
//
//  Created by mike hargrove on 12/29/14.
//  Copyright (c) 2014 mike hargrove. All rights reserved.
//

import Foundation
import UIKit
import CoreData;

class PostViewController: RipplBaseViewController, UITextViewDelegate {
    
    let className = "PostViewController"
    
    
    let messaging:Messaging = Messaging();
    
    var keyboardShowing = false
    
    var defaultLatitude : Double! = 0;
    var defaultLongitude : Double! = 0;
    
    
    var textView : UITextView!
    
    var postButton : UIButton!
    var cancelButton : UIButton!
    
    var textViewXConstraint:NSLayoutConstraint!
    var textViewYConstraint:NSLayoutConstraint!
    var textViewWidthConstraint:NSLayoutConstraint!
    //var textViewHeightConstraint:NSLayoutConstraint!
    var textViewBottomConstraint:NSLayoutConstraint!
    
    
    var cancelButtonHeightConstraint:NSLayoutConstraint!
    var postButtonHeightConstraint:NSLayoutConstraint!
    var cancelButtonWidthConstraint:NSLayoutConstraint!
    var postButtonWidthConstraint:NSLayoutConstraint!
    

    var cancelButtonBottomConstraint:NSLayoutConstraint!
    var postButtonBottomConstraint:NSLayoutConstraint!
    
    var postButtonLeadingConstraint:NSLayoutConstraint!
    var cancelButtonLeadingConstraint:NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let funcName = "viewDidLoad";
        
        let util = Utility();
        
        currentViewController = Navigator().LOCATION_POST
        
        Logging.debug(className, methodName: funcName, logline:"Post Message View Controller")
        

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostViewController.keyboardShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostViewController.keyboardHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

//buttons

    
        postButton = UIButton(type:.System)
        postButton.setTitle("post", forState: UIControlState.Normal)
        postButton.addTarget(self, action: #selector(PostViewController.postMessage), forControlEvents: .TouchUpInside)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.backgroundColor = util.defaultColorBlue();
        postButton.layer.cornerRadius = 0
        postButton.layer.borderWidth = 0
        postButton.layer.borderColor = UIColor.clearColor().CGColor


        cancelButton = UIButton(type:.System)
        cancelButton.setTitle("cancel", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: #selector(PostViewController.fence), forControlEvents: .TouchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = util.defaultColorBlue();
        cancelButton.layer.cornerRadius = 0
        cancelButton.layer.borderWidth = 0
        cancelButton.layer.borderColor = UIColor.clearColor().CGColor

        
        self.view.addSubview(postButton)
        self.view.addSubview(cancelButton)
        
        
        
        textView = UITextView()
        textView.delegate = self;
        
        textView.backgroundColor = UIColor(red:250.0/255.0, green:250.0/255.0, blue:250.0/255.0, alpha:1.0)
        textView.translatesAutoresizingMaskIntoConstraints = false;
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.backgroundColor = UIColor.whiteColor().CGColor
        textView.keyboardAppearance = UIKeyboardAppearance.Default
        textView.keyboardType = UIKeyboardType.Default
        textView.font = UIFont (name: "Helvetica Neue", size: 22)
        
        textView.returnKeyType = UIReturnKeyType.Done
        self.view.addSubview(textView)
        
        layoutStandardConstraints()
        
        //self.tabBarController.

        
        // Do any additional setup after loading the view.
    }
    
    func layoutStandardConstraints()  {
        
        cancelButtonHeightConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier:1, constant: 40)
        view.addConstraint(cancelButtonHeightConstraint);
        
        cancelButtonWidthConstraint =  NSLayoutConstraint(item: cancelButton, attribute: .Width, relatedBy: .Equal,
            toItem: self.view, attribute: .Width, multiplier:0.50, constant: 0)
        view.addConstraint(cancelButtonWidthConstraint);
        
        cancelButtonBottomConstraint =  NSLayoutConstraint(item: cancelButton, attribute: .Bottom, relatedBy: .Equal,
            toItem: self.bottomLayoutGuide, attribute: .Top, multiplier:1, constant: 0)
        view.addConstraint(cancelButtonBottomConstraint);
        
        postButtonHeightConstraint = NSLayoutConstraint(item: postButton, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier:1, constant: 40)
        view.addConstraint(postButtonHeightConstraint);
        
        postButtonWidthConstraint =  NSLayoutConstraint(item: postButton, attribute: .Width, relatedBy: .Equal,
            toItem: self.view, attribute: .Width, multiplier:0.50, constant: 0)
        view.addConstraint(postButtonWidthConstraint);
        
        postButtonBottomConstraint =  NSLayoutConstraint(item: postButton, attribute: .Bottom, relatedBy: .Equal,
            toItem: bottomLayoutGuide, attribute: .Top, multiplier:1, constant: 0)
        view.addConstraint(postButtonBottomConstraint);
        
        
        postButtonLeadingConstraint =  NSLayoutConstraint(item: postButton, attribute: .Leading, relatedBy: .Equal,
            toItem: cancelButton, attribute: .Trailing, multiplier:1, constant: 0)
        view.addConstraint(postButtonLeadingConstraint);
        
        cancelButtonLeadingConstraint =  NSLayoutConstraint(item: cancelButton, attribute: .Leading, relatedBy: .Equal,
            toItem: view, attribute: .Leading, multiplier:1, constant: 0)
        view.addConstraint(cancelButtonLeadingConstraint);
        
        
        textViewXConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal,
            toItem: view , attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(textViewXConstraint)
        
        textViewYConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 30)
        self.view.addConstraint(textViewYConstraint)
        
        
        textViewWidthConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -24)
        self.view.addConstraint(textViewWidthConstraint)
        
        textViewBottomConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal, toItem: postButton, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -8)
        self.view.addConstraint(textViewBottomConstraint)
        
        
    }
    
    func layoutWithKeyboard(height:CGFloat)  {
        
        let funcName = "layoutWithKeyboard";
        
        Logging.debug(className, methodName: funcName, logline:"height: \(height)")
        view.removeConstraint(cancelButtonBottomConstraint);

                //view.removeConstraint(postButtonBottomConstraint);
        
        cancelButtonBottomConstraint = NSLayoutConstraint(item: cancelButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
            toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -(height+8))
        self.view.addConstraint(cancelButtonBottomConstraint)
        
        
        
    }
    
    func layoutWithoutKeyboard() {
        
        view.removeConstraint(cancelButtonBottomConstraint);

        cancelButtonBottomConstraint =  NSLayoutConstraint(item: cancelButton, attribute: .Bottom, relatedBy: .Equal,
            toItem: view, attribute: .Bottom, multiplier:1, constant: -8)
        view.addConstraint(cancelButtonBottomConstraint);
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        textView.becomeFirstResponder();
        //println("textview height [\(textView.frame.height)], width [\(textView.frame.width)]")
        
        
    }
    
    /*
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool  {
        return false
    }
    
    func textViewDidBeginEditing(textView: UITextView)  {
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {  //delegate method
        return false
    }
    
    func textViewDidEndEditing(textView: UITextView)  {
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool    {
        return true
    }
    
    func textViewDidChange(textView: UITextView)  {
        
    }
    
    func textViewDidChangeSelection(textView: UITextView)  {
        
    }
    
    func textView(textView: UITextView,
        shouldInteractWithTextAttachment textAttachment: NSTextAttachment,
        inRange characterRange: NSRange) -> Bool {
            return false;
    }
    
    func textView(textView: UITextView,
        shouldInteractWithURL URL: NSURL,
        inRange characterRange: NSRange) -> Bool  {
            return false;
    }
    
    
    
    */
    

    
    
    
    func keyboardShow(n:NSNotification) {
        
        let funcName = "keyboardShow";
        
        
        Logging.debug(className, methodName: funcName, logline:"keyboardShow")
        
        self.keyboardShowing = true
        
        
        
        let d = n.userInfo!
        let r = (d[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //var newHeight = self.view.frame.height - r.height - 38
        
        //r = self.textView.convertRect(r, fromView:nil)
        //self.textView.contentInset.bottom = r.size.height
        //self.textView.scrollIndicatorInsets.bottom = r.size.height
        
        layoutWithKeyboard(r.height)
        //println("textview height [\(textView.frame.height)], width [\(textView.frame.width)]")
        //println("textview origin x [\(textView.frame.origin.x)], origin y [\(textView.frame.origin.y)]")
    
        
        
    }
    
    func keyboardHide(n:NSNotification) {
        let funcName = "keyboardHide";
        
        Logging.debug(className, methodName: funcName, logline:"keyboardHide")
        
        self.keyboardShowing = false
        //self.textView.contentInset = UIEdgeInsetsZero
        //self.textView.scrollIndicatorInsets = UIEdgeInsetsZero
        
        //layoutWithoutKeyboard()
        
    }
    
    func doDone(sender:AnyObject) {
        self.view.endEditing(false)
    }
    
     func fence() {
        let funcName = "fence";
        self.tabBarController!.performSegueWithIdentifier("goTargetLocation", sender: self);
        Logging.debug(className, methodName: funcName, logline:"target location")
        
    }

    
   
    func postMessage() {
        
        let funcName = "postMessage";
        
        if textView.text != ""  {
            
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            defaultLatitude = appDelegate.lastLatitude
            defaultLongitude = appDelegate.lastLongitude

            
            var username : String = "";
            
            if let uname:String = prefs.objectForKey("UUID") as? String  {
                username = uname;
            }
            
            let message : Message = Message()
            
            
            
            
            
            let uuid = NSUUID().UUIDString
            
            
            message.messageId = uuid;
            message.userId = username;
            message.disposition = Constants().kDISPOSITION_UNPOSTED;
            message.createDate = NSDate();
            message.content = textView.text
            message.latitude = defaultLatitude
            message.longitude = defaultLongitude
            
            Logging.debug(className, methodName: funcName, logline:"post message: uuid \(username) location latitude [\(message.latitude)] longitude [\(message.longitude)]")
            

            
            messaging.addMessage(message, disposition: Constants().kDISPOSITION_UNPOSTED);
            
            let notification = NSNotification(name:"postMessage", object: self, userInfo:nil);
            NSNotificationCenter.defaultCenter().postNotification(notification);
            
            textView.text = "";
            
            let nav: Navigator =  Navigator();
            let path : Int = Navigator.transitionPath(currentViewController, leftOrRight: nav.DIRECTION_LEFT)
            self.tabBarController?.selectedIndex = path;
        }
        
  
        
                
    }
    
   
   
}
       