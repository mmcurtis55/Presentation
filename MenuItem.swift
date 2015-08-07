//
//  MenuItem.swift
//  HackathonApp
//
//  Created by Matthew Curtis on 8/6/15.
//  Copyright (c) 2015 Matthew Curtis. All rights reserved.
//

import Foundation
import CoreData

class MenuItem: NSManagedObject {

    @NSManaged var type: String
    @NSManaged var title: String
    @NSManaged var tint: String
    @NSManaged var thumbnail: NSData
    @NSManaged var size: String
    @NSManaged var segueUrl: String
    @NSManaged var label: String
    @NSManaged var iconUrl: String
    @NSManaged var created: NSDate
    @NSManaged var color: String

}
