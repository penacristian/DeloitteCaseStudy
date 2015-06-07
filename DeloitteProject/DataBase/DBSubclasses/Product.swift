//
//  Product.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/6/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import Foundation
import CoreData

class Product: NSManagedObject {

    @NSManaged var productName: String
    @NSManaged var productId: NSNumber
    @NSManaged var price: NSNumber
    @NSManaged var oldPrice: NSNumber
    @NSManaged var stock: NSNumber
    @NSManaged var isWishlisted: NSNumber
    @NSManaged var category: Category
    @NSManaged var shoppingCart: ShoppingCart?

}
