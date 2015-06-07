//
//  DataManager.swift
//  Unico
//
//  Created by Cristian Pena on 3/27/15.
//  Copyright (c) 2015 Unico. All rights reserved.
//

import CoreData

public class DataManager : NSObject {
   
    private let concurrentDataQueue = dispatch_queue_create("com.clothesStore.DataQueue", DISPATCH_QUEUE_CONCURRENT)
    
    public class var sharedInstance: DataManager {
        struct Singleton {
            
            static let instance = DataManager()
        }
        
        return Singleton.instance
    }
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last as! NSURL
        }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("ClothesStore", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("DeloitteProject.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true], error: &error) == nil {
            println("Error creating store. Removing existing store...")
            if NSFileManager.defaultManager().removeItemAtURL(url, error: &error) {
                if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
                    println("Error creating store (second attempt")
                }
            } else {
                println("Error deleting store")
            }
        }
        return coordinator
        }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    private func _insert(type: String) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName(type, inManagedObjectContext: self.managedObjectContext) as! NSManagedObject
    }
    
    func insert(type: String) -> NSManagedObject {
        var obj: NSManagedObject? = nil
        self.managedObjectContext.performBlockAndWait { () -> Void in
            obj = self._insert(type)
        }
        return obj!
    }
    
    
    private func _deleteObject(object: NSManagedObject) {
        self.managedObjectContext.deleteObject(object)
    }
    
    func deleteObject(object: NSManagedObject) {
        self.managedObjectContext.performBlockAndWait { () -> Void in
            self._deleteObject(object)
        }
    }
    
    private func _fetch(type: String, predicate: NSPredicate?, sort: [NSSortDescriptor]?, limit: Int?) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: type)
        fetchRequest.entity = NSEntityDescription.entityForName(type, inManagedObjectContext: self.managedObjectContext)
        fetchRequest.includesSubentities = true
        fetchRequest.fetchBatchSize = 20
        if let l = limit {
            fetchRequest.fetchLimit = l
        }
        if let s = sort {
            fetchRequest.sortDescriptors = s
        }
        if let p = predicate {
            fetchRequest.predicate = p
        }
        var error: NSError? = nil
        return self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]
    }
    
    func fetch(type: String, predicate: NSPredicate?, sort: [NSSortDescriptor]?, limit: Int?) -> [NSManagedObject] {
        var result:[NSManagedObject]? = nil
        self.managedObjectContext.performBlockAndWait { () -> Void in
            result = self._fetch(type, predicate: predicate, sort: sort, limit: limit)
        }
        return result!
    }
    
    func first(type: String, predicate: NSPredicate?, sort: [NSSortDescriptor]?, limit: Int?) -> NSManagedObject? {
        var result:[NSManagedObject]? = nil
        self.managedObjectContext.performBlockAndWait { () -> Void in
            result = self._fetch(type, predicate: predicate, sort: sort, limit: limit)
        }
        return result!.first
    }
    
    private func _count(type: String, predicate: NSPredicate?) -> Int {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName(type, inManagedObjectContext: self.managedObjectContext)
        fetchRequest.includesSubentities = false
        if let p = predicate {
            fetchRequest.predicate = p
        }
        var error: NSError? = nil
        return self.managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
    }
    
    func count(type: String, predicate: NSPredicate?) -> Int {
        var result: Int = 0
        self.managedObjectContext.performBlockAndWait { () -> Void in
            result = self._count(type, predicate: predicate)
        }
        return result
    }
    
    private func _save(changes: ((Void) -> Void)?) {
        var error: NSError? = nil
        
        if let changes = changes {
            changes()
        }
        self.managedObjectContext.save(&error)
    }
    
    func save(changes: ((Void) -> Void)?) {
        self.managedObjectContext.performBlockAndWait({ () -> Void in
            self._save(changes)
        })
    }
    
    class func save(changes: ((Void) -> Void)?) {
        DataManager.sharedInstance.save(changes)
    }
    
    func updateProductsFromJson(data:[[String:AnyObject]]) {
        for productData in data {
            Product.fromJson(productData)
        }
    }
    
    func getCategories() -> [Category] {
        let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
        return fetch(kCategory, predicate: nil, sort: [sortDescriptor], limit: nil) as! [Category]
    }
    
    func getWishlist() -> [Product] {
        let sortDescriptor = NSSortDescriptor(key: "category.categoryName", ascending: true)
        let predicate = NSPredicate(format: "isWishlisted == true")
        return fetch(kProduct, predicate: predicate, sort: [sortDescriptor], limit: nil) as! [Product]
    }
}
