//
//  CollectionViewCell.swift
//  HackathonApp
//
//  Created by Matthew Curtis on 8/6/15.
//  Copyright (c) 2015 Matthew Curtis. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewCell: UICollectionViewCell {
    
    // used to get the menuItem backed by this UI component
    var objectId: NSManagedObjectID!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    var segue: String!
    
    // TODO: add a var that will get the menu item from CoreData or just the MenuItem itself
    
    
}
