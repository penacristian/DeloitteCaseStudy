//
//  Product+Extensions.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/5/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import Foundation
import CoreData

let kProduct = "Product"
let kProductId = "productId"
let kProductName = "name"
let kProductCategory = "category"
let kProductPrice = "price"
let kProductOldPrice = "oldPrice"
let kProductStock = "stock"


extension Product {
    class func newProduct() -> Product {
        var product = DataManager.sharedInstance.insert(kProduct) as! Product
        
        
        return product
    }
    
    class func withId(id: Int) -> Product? {
        let product = DataManager.sharedInstance.first(kProduct, predicate: NSPredicate(format: "productId = %d", id), sort: nil, limit: 1) as! Product?
        return product
    }
    
    class func fromJson(data: [String: AnyObject]) -> Product? {
        if let id = data[kProductId] as? Int {
            var obj = Product.withId(id)
            var result: Product
            if obj == nil {
                result = newProduct()
                result.productId = id
            } else {
                result = obj!
            }
            result.updateWithJson(data)
            DataManager.save(nil)
            return result
        } else {
            return nil
        }
    }
    
    func updateWithJson(data: [String: AnyObject]) {
        if let nameString = data[kProductName] as? String {
            productName = nameString
        }
        if let categoryString = data[kProductCategory] as? String {
            category = Category.fromName(categoryString)
        }
        if let priceNumber = data[kProductPrice] as? Double {
            price = priceNumber
        }
        if let oldPriceNumber = data[kProductOldPrice] as? Double {
            oldPrice = oldPriceNumber
        }
        if let stockNumber = data[kProductStock] as? Int {
            stock = stockNumber
        }
    }
}
