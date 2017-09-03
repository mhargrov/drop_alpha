//
//  LocalSession.swift
//  Rippl
//
//  Created by mike hargrove on 7/24/15.
//  Copyright © 2015 mike hargrove. All rights reserved.
//

import Foundation
import MultipeerConnectivity


protocol LocalSessionDelegate  {
    
    func connectedDevicesChanged(localsession: LocalSession, connectedPeers: [String])
    func messageRecieved(localsession: LocalSession, message: Message)
    func addPeer(peerId:String)
    func removePeer(peerId:String)
    func saveMessage(message:Message)
    
}


class LocalSession : NSObject  {
    
    let className = "LocalSession";
    
    private let LocalSessionServiceType = "ripplservice"
    
    private var senderId:String = "";
    
 
    private var servicePeerId:MCPeerID
    
    
    private let serviceBrowser:MCNearbyServiceBrowser
    private let serviceAdvertiser:MCNearbyServiceAdvertiser
    
    var delegate : LocalSessionDelegate?;
    
    private var foundPeers: Set<String> = Set<String>();
    

    
    init(sender:String)  {
   
        let funcName = "init";
        
        senderId = sender;
   
        Logging.log(className, methodName: funcName, logline:"delegate is nil [\((delegate == nil))]");
        
        servicePeerId = MCPeerID(displayName: senderId);
   
        Logging.log(className, methodName: funcName, logline:"delegate is nil [\((delegate == nil))]");
        
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: servicePeerId, discoveryInfo: nil, serviceType: LocalSessionServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: servicePeerId, serviceType: LocalSessionServiceType)
       
        Logging.log(className, methodName: funcName, logline:"delegate is nil [\((delegate == nil))]");
         super.init();
        
        Logging.log(className, methodName: funcName, logline:"delegate is nil [\((delegate == nil))]");
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
       
        Logging.log(className, methodName: funcName, logline:"delegate is nil [\((delegate == nil))]");
        
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.servicePeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Optional)
        session.delegate = self;
        return session;
    }()
    
    
    
    func checkDelegate () {
        let funcName = "checkDelegate";
        Logging.log(className, methodName: funcName, logline:"delegate is nil [\((delegate == nil))]");
    }
    
    
    func sendMessage(message:Message)  {
        
        let funcName = "sendMessage()";
        
        //Logging.log(className, methodName: funcName, logline:"sendMessage");
        
        //Logging.log(className, methodName: funcName, logline:"connected peer count is [\(session.connectedPeers.count)]");
        
        if(session.connectedPeers.count > 0)  {
           
            let peers: [MCPeerID] = session.connectedPeers
            
            let messageJson:String = "";//message.formatMessagePut();
            
            do {
                Logging.log(className, methodName: funcName, logline:"sending message to peer: connected peer count is [\(session.connectedPeers.count)]");
                try self.session.sendData(messageJson.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, toPeers: peers, withMode: MCSessionSendDataMode.Reliable)
                
            }
            catch {
                Logging.log(self.className, methodName: funcName, logline:"error \(error)")
            }
            
        }
        
        
        
        /*
        multipeerPeer = MCPeerID(displayName: sender);
        
        multipeerSession = MCSession(peer: multipeerPeer);
        multipeerSession.delegate = self;
        
        Logging.log(className, methodName: funcName, logline:"session created")
        
        multipeerBrowser = MCNearbyServiceBrowser(peer: multipeerPeer, serviceType: "ripplservice");
        multipeerBrowser.delegate = self;
        multipeerBrowser.startBrowsingForPeers();
        
        Logging.log(className, methodName: funcName, logline:"start browser")
        
        multipeerAdvertiser = MCNearbyServiceAdvertiser(peer: multipeerPeer, discoveryInfo: nil, serviceType: "ripplservice");
        multipeerAdvertiser.delegate = self;
        multipeerAdvertiser.startAdvertisingPeer();
        
        Logging.log(className, methodName: funcName, logline:"start advertiser")
        */
        
    }


}



    // MARK: MCNearbyServiceBrowserDelegate method implementation


extension LocalSession : MCNearbyServiceBrowserDelegate  {

    @objc func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        let funcName = "browser foundPeer";
        
        Logging.log(className, methodName: funcName, logline:"delegate is nil [\((delegate == nil))]");
        self.delegate?.addPeer(peerID.displayName);
        //foundPeers.append(peerID)
        Logging.log(className, methodName: funcName, logline:"found peer [\(peerID.displayName)]");
        let userInfoDict: [String:String] = ["uuid": peerID.displayName];
        let notification = NSNotification(name:"startRangingBeacon", object: self, userInfo:userInfoDict);
        NSNotificationCenter.defaultCenter().postNotification(notification);
        foundPeers.insert(peerID.displayName);
        
        
        let myHash = servicePeerId.hash;
        let peerHash = peerID.hash;
        
        Logging.log(className, methodName: funcName, logline:"my hash [\(myHash)], peer hash [\(peerHash)]");
        
        if(Int64(myHash) > Int64(peerHash)) {
            serviceBrowser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 30);
        }
        
        
    }
    
    
    @objc func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        let funcName = "browser lostPeer";
        Logging.log(className, methodName: funcName, logline:"lost peer [\(peerID.displayName)]")
        foundPeers.remove(peerID.displayName);
        self.delegate?.removePeer(peerID.displayName)

    }
    
    
    @objc func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        let funcName = "browser didNotStartBrowsingForPeers";
        Logging.log(className, methodName: funcName, logline:error.localizedDescription)
    }
    
}

    // MARK: MCSessionDelegate method implementation

extension LocalSession : MCSessionDelegate  {
    
    @objc func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        let funcName = "session didChangeState";
        
        
        var stateDescription = "";
        
        switch state  {
        case MCSessionState.Connected:
            stateDescription = "Connected to session"
            //delegate?.connectedWithPeer(peerID)
        case MCSessionState.Connecting:
            stateDescription = "Connecting to session"
        case MCSessionState.NotConnected:
            stateDescription = "Not connected to session"
            Logging.log(className, methodName: funcName, logline:"connected peer count: \(session.connectedPeers.count)")
            //serviceBrowser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 30);
        }
        
        Logging.log(className, methodName: funcName, logline:"----> multipeer session did change state: \(stateDescription)")
        self.delegate?.connectedDevicesChanged(self, connectedPeers: session.connectedPeers.map({$0.displayName}))
    }
    
    @objc func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        //let dictionary: [String: AnyObject] = ["data": data, "fromPeer": peerID]
        
        let funcName = "session didReceiveData";
        
         Logging.log(className, methodName: funcName, logline:"--> didReceiveData")
        
        let jsonData: AnyObject?
        do {
            jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch  {
            Logging.log(self.className, methodName: funcName, logline:"error \(error)")
            jsonData = nil
        }
        
        //Logging.log(self.className, methodName: funcName, logline:"json data is nil \(jsonData == nil)")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // superset of OP's format
        
        
        /*
request += "{\n "
request += "\"aoc\":\"message\",\n \"action\":\"put\",\n "
request += " \"username\": \"\(userIdentifier)\",\n"
request += " \"recipient\": \"\(recipient)\",\n"
request += " \"message\": \"\(message)\",\n"
request += " \"messageIdentifier\": \"\(messageIdentifier)\",\n"
request += " \"latitude\": \(location.latitude),\n"
request += " \"longitude\": \(location.longitude),\n"
request += " \"postDateTime\": \"\(postDateTimeValue)\",\n"
request += " \"precision\": \(precision)\n"
request += " }"
*/


        if let dict = jsonData as? NSDictionary {
         
Logging.log(className, methodName: funcName, logline:"dictionalry defined")
            let recievedMessage:Message =  Message();
                    
                    //parse message
            if let uuid = dict["uuid"] as? NSString {
                        recievedMessage.messageId = uuid as String;
            }
                    
            if let owner = dict["username"] as? NSString  {
                        recievedMessage.userId = owner as String;
            }
            
            if let messageIdent = dict["messageIdentifier"] as? NSString  {
                recievedMessage.messageId = messageIdent as String;
            }
            
            if let message = dict["message"] as? NSString  {
                recievedMessage.content = message as String;
            }
                    
            //if let precision = dict["precision"] as? Double {
            //    recievedMessage.precision = precision as Double;
            //}
            //
            //let location:Location = Location();
            
            if let longitudeValue = dict["longitude"] as? Double {
                recievedMessage.longitude = longitudeValue as Double;
            }
            
            if let latitudeValue = dict["latitude"] as? Double {
                recievedMessage.latitude = latitudeValue as Double;
            }
            
            //recievedMessage.location = location;
            
            recievedMessage.disposition = Constants().kDISPOSITION_UNDEFINED;
            
            Logging.log(className, methodName: funcName, logline:"message \(recievedMessage.content)")
            
            //Logging.log(self.className, methodName: funcName, logline:"about to parse post date")
            if let postDateValue = dict["postDate"] as? NSString  {
                //Logging.log(self.className, methodName: funcName, logline:"\(postDateValue)");
                let postDate = dateFormatter.dateFromString(postDateValue as String);
                if let pd = postDate {
                    recievedMessage.createDate = pd;
                }
            }
            
            Logging.log(className, methodName: funcName, logline:"about to save message \(recievedMessage.content)")
            Logging.log(className, methodName: funcName, logline:"delegate is null \((self.delegate == nil))")
            self.delegate?.saveMessage(recievedMessage);
            //Logging.log(self.className, methodName: funcName, logline:"finished parsing postDate");
                    
                    /*
                    if let expirationDateValue = dict["postDate"] as? NSString  {
                    let expirationDate = dateFormatter.dateFromString(expirationDateValue as String);
                    recievedMessage.executionDateTime = expirationDate!;
                    }
                    */
                    /*
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // superset of OP's format
                    lastMessageCheckDateTime = dateFormatter.stringFromDate(NSDate())
                    */
                    
                    //add to array



        }

        /*
        if let  beaconData:NSUUID = dictionary["uuid"] as? NSUUID  {
            Logging.log(className, methodName: funcName, logline:"beacon identifier [\(beaconData.UUIDString)], from peer \(peerID.description)")
        }
        */
        //NSNotificationCenter.defaultCenter().postNotificationName("receivedMPCDataNotification", object: dictionary)
    }
    
    
    @objc func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) { }
    
    @objc func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) { }
    
    @objc func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    
    
}

    // MARK: MCNearbyServiceAdvertiserDelegate method implementation
    
extension LocalSession : MCNearbyServiceAdvertiserDelegate  {

    @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        
        let funcName = "advertiser didReceiveInvitationFromPeer";
        Logging.log(className, methodName: funcName, logline:"didReceiveInvitationFromPeer -------> did recieve invitaion from peer \(peerID.displayName)")
        invitationHandler(true, self.session)
    }
    
    
    @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        let funcName = "advertiser didNotStartAdvertisingPeer";
        Logging.log(className, methodName: funcName, logline:"didNotStartAdvertisingPeer:" + error.localizedDescription)
    }
    
}

    

