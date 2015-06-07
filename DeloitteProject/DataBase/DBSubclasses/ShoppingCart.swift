//
//  ShoppingCart.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/6/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import Foundation
import CoreData

class ShoppingCart: NSManagedObject {

    @NSManaged var cartId: NSNumber
    @NSManaged var products: NSSet

}
