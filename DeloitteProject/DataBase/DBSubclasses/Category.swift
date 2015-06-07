//
//  Category.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/6/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var categoryName: String
    @NSManaged var products: NSSet

}
