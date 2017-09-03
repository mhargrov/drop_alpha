//
//  PeerQueue+CoreDataProperties.swift
//  Rippl
//
//  Created by mike hargrove on 7/12/15.
//  Copyright © 2015 mike hargrove. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension PeerQueue {

    @NSManaged var userIdentifier: String?
    @NSManaged var name: String?
    @NSManaged var saved: NSNumber?

}
