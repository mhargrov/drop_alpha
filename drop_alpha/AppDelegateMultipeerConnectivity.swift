//
//  AppDelegateMultipeer.swift
//  Rippl
//
//  Created by mike hargrove on 5/16/15.
//  Copyright (c) 2015 mike hargrove. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import CoreData

extension AppDelegate {//MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate  {
    


    
    /*
    func startMultipeer()  {
        
        let funcName = "startMultipeer()";
        
        Logging.log(className, methodName: funcName, logline:"startMultipeer()");
        
        multipeerPeer = MCPeerID(displayName: uuid.UUIDString);
        
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
        
        
    }
    
    // MARK: MCNearbyServiceBrowserDelegate method implementation
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        let funcName = "browser foundPeer";
        foundPeers.append(peerID)
        Logging.log(className, methodName: funcName, logline:"found peer [\(peerID.displayName)]");
        let userInfoDict: [String:String] = ["uuid": peerID.displayName];
        let notification = NSNotification(name:"startRangingBeacon", object: self, userInfo:userInfoDict);
        NSNotificationCenter.defaultCenter().postNotification(notification);
        
        //multipeerBrowser.invitePeer(peerID, toSession: multipeerSession, withContext: nil, timeout: 20)
        //delegate?.foundPeer()
    }
    
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        let funcName = "browser lostPeer";
        Logging.log(className, methodName: funcName, logline:"lost peer [\(peerID.displayName)]")
        for (index, aPeer) in foundPeers.enumerate(){
            if aPeer == peerID {
                foundPeers.removeAtIndex(index)
                break
            }
        }
        
        //delegate?.lostPeer()
    }
    
    
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        let funcName = "browser didNotStartBrowsingForPeers";
        Logging.log(className, methodName: funcName, logline:error.localizedDescription)
    }
    
    
    
    // MARK: MCSessionDelegate method implementation
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
        let funcName = "session didChangeState";
        
       
        var stateDescription = "";
        
        switch state{
            case MCSessionState.Connected:
                stateDescription = "Connected to session"
                //delegate?.connectedWithPeer(peerID)
            case MCSessionState.Connecting:
                stateDescription = "Connecting to session"
            case MCSessionState.NotConnected:
                stateDescription = "Not connected to session"

        }

        Logging.log(className, methodName: funcName, logline:"----> multipeer session did change state: \(stateDescription)")

    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        //let dictionary: [String: AnyObject] = ["data": data, "fromPeer": peerID]
        
        let funcName = "session didReceiveData";
        Logging.log(className, methodName: funcName, logline:"--> didReceiveData")
        
        
        let dictionary:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data)! as! NSDictionary
        
        //dictionary.objectForKey(<#aKey: AnyObject#>)
        
        if let  beaconData:NSUUID = dictionary["uuid"] as? NSUUID  {
            Logging.log(className, methodName: funcName, logline:"beacon identifier [\(beaconData.UUIDString)], from peer \(peerID.description)")
        }
        
        //NSNotificationCenter.defaultCenter().postNotificationName("receivedMPCDataNotification", object: dictionary)
    }
    
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) { }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError) { }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    
 
    
    
    // MARK: MCNearbyServiceAdvertiserDelegate method implementation
    
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        
        let funcName = "advertiser didReceiveInvitationFromPeer";
        Logging.log(className, methodName: funcName, logline:"didReceiveInvitationFromPeer -------> did recieve invitaion from peer \(peerID.displayName)")
        //self.invitationHandler =
        
        //

        
        invitationHandler(true, multipeerSession)
        
        //delegate?.invitatiCBPonWasReceived(peerID.displayName)displayName
    }
    
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        let funcName = "advertiser didNotStartAdvertisingPeer";
        Logging.log(className, methodName: funcName, logline:"didNotStartAdvertisingPeer:" + error.localizedDescription)
    }
*/
    
}
