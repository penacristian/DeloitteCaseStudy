//
//  Category+Extensions.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/5/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import Foundation
import CoreData

let kCategory = "Category"

extension Category {
    class func newCategory() -> Category {
        var category = DataManager.sharedInstance.insert(kCategory) as! Category
        return category
    }
    
    class func withName(name: String) -> Category? {
        let category = DataManager.sharedInstance.first(kCategory, predicate: NSPredicate(format: "categoryName = %@", name), sort: nil, limit: 1) as! Category?
        return category
    }
    
    class func fromName(name: String) -> Category {
        var obj = Category.withName(name)
        var result: Category
        if obj == nil {
            result = newCategory()
            result.categoryName = name
        } else {
            result = obj!
        }
        DataManager.save(nil)
        return result
    }
    
    func getProducts() -> [Product] {
        let sortDescriptor = NSSortDescriptor(key: "productName", ascending: true)
        var array = products.sortedArrayUsingDescriptors([sortDescriptor]) as! [Product]
        return array
    }
}