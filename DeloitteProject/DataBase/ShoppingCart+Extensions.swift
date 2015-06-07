//
//  ShoppingCart+Extensions.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/7/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import Foundation
import CoreData

let kShoppingCart = "ShoppingCart"
let kShoppingCartId = "cartId"

private var _GLOBAL_CART: ShoppingCart?

extension ShoppingCart {
    
    class func newShoppingCart() -> ShoppingCart {
        var shoppingCart = DataManager.sharedInstance.insert(kShoppingCart) as! ShoppingCart
        return shoppingCart
    }

    class var activeCart: ShoppingCart! {
        get {
            if (_GLOBAL_CART == nil) {
                if let cart = DataManager.sharedInstance.first(kShoppingCart, predicate: nil, sort: nil, limit: 1) as! ShoppingCart? {
                    _GLOBAL_CART = cart
                } else {
                    _GLOBAL_CART = ShoppingCart.newShoppingCart()
                }
            }
            return _GLOBAL_CART;
        }
        set(newCart) {
            if let previousCart = _GLOBAL_CART {
                DataManager.sharedInstance.deleteObject(previousCart)
            }
            _GLOBAL_CART = newCart;
        }
    }
    
    func addItem(product:Product,completion:ServiceResponse) {
        if products.containsObject(product) {
            completion(result: "Item already in Cart", error: NSError())
        } else {
            Service.addItemToCart(product, completion: { (result, error) -> Void in
                if error == nil {
                    if let cartIdString = (result as! [String:AnyObject])[kShoppingCartId] as? Int {
                        self.cartId = cartIdString
                    }
                    self.addProduct(product)
                    if product.isWishlisted.boolValue {
                        product.isWishlisted = false
                    }
                    DataManager.save(nil)
                    completion(result: nil, error: nil)
                } else {
                    completion(result: result, error: error)
                }
            })
        }
    }
    
    func removeItem(product:Product,completion:ServiceResponse) {
        if !products.containsObject(product) {
            completion(result: "Item not in Cart", error: NSError())
        } else {
            Service.removeItemFromCart(product, completion: { (result, error) -> Void in
                if error == nil {
                    self.removeProduct(product)
                    DataManager.save(nil)
                    completion(result: nil, error: nil)
                } else {
                    completion(result: result, error: error)
                }
            })
        }
    }
    
    func containsItem(product:Product) -> Bool {
        return products.containsObject(product)
    }
    
    func getProducts() -> [Product] {
        let sortDescriptor = NSSortDescriptor(key: "productName", ascending: true)
        var array = products.sortedArrayUsingDescriptors([sortDescriptor]) as! [Product]
        return array
    }
    
    func getTotalPrice() -> Double {
        var totalPrice = 0.0
        for product in getProducts() {
            totalPrice += product.price.doubleValue
        }
        return totalPrice
    }
}

extension ShoppingCart {
    func addProduct(product:Product) {
        product.shoppingCart = self
//        var items = self.mutableSetValueForKey("Products");
//        items.addObject(product)
    }
    
    func removeProduct(product:Product) {
        product.shoppingCart = nil
//        var items = self.mutableSetValueForKey("Products");
//        items.removeObject(product)
    }

}