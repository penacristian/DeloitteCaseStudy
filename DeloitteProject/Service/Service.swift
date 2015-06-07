//
//  Service.swift
//  DeloitteProject
//
//  Created by Cristian Pena on 6/5/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

import Foundation

typealias ServiceResponse = (result:AnyObject?, error:NSError?) -> Void;

class Service {
    
    class func getProducts(completion:ServiceResponse) {
        
        let url = NSURL(string: "http://private-anon-8023d3f4b-ddshop.apiary-mock.com/products")!
        
        var request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
        
        var session = NSURLSession.sharedSession()
        
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
            
            if connectionError == nil {
                let httpResponse = response as! NSHTTPURLResponse
                
                switch (httpResponse.statusCode) {
                case 200:
                    var error: NSError? = nil
                    if let searchResultsArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? [[String:AnyObject]] {
                        
                        DataManager.sharedInstance.updateProductsFromJson(searchResultsArray)
                        completion(result: nil, error: nil)
                    } else {
                        completion(result: "There was a problem.", error: NSError())
                    }
                default:
                    completion(result: "There was a problem.", error: NSError())
                }
            }
        })
        task.resume()
    }
    
    class func addItemToCart(product:Product,completion:ServiceResponse) {
        
        let url = NSURL(string: "http://private-anon-8023d3f4b-ddshop.apiary-mock.com/cart")!
        
        var request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postString = "productId=\(product.productId)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        var session = NSURLSession.sharedSession()
        
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
            
            if connectionError == nil {
                let httpResponse = response as! NSHTTPURLResponse
                switch (httpResponse.statusCode) {
                case 201:
                    var error: NSError? = nil
                    if let resultsDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? [String:AnyObject] {
                        completion(result: resultsDictionary, error: nil)
                    } else {
                        completion(result: "There was a problem.", error: NSError())
                    }
                default:
                    completion(result: "There was a problem.", error: NSError())
                }
            }

        })
        task.resume()
    }
    
    class func removeItemFromCart(product:Product, completion:ServiceResponse) {
        
        let url = NSURL(string: "http://private-anon-8023d3f4b-ddshop.apiary-mock.com/cart/\(ShoppingCart.activeCart.cartId)")!
        
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        request.setValue("", forHTTPHeaderField: "Accept-Encoding")
        
        let session = NSURLSession.sharedSession()
        
        var start:NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, connectionError) -> Void in
            var timeResponse:NSTimeInterval = NSDate.timeIntervalSinceReferenceDate() - start
            println("\(timeResponse)")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if connectionError == nil {
                    let httpResponse = response as! NSHTTPURLResponse
                    switch (httpResponse.statusCode) {
                    case 204:
                        completion(result: nil, error: nil)
                    default:
                        completion(result: "There was a problem.", error: NSError())
                    }
                }
            })
        })
        task.resume()
    }
}
