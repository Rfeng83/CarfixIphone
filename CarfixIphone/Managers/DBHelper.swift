//
//  DBHelper.swift
//  Carfix2
//
//  Created by Re Foong Lim on 25/03/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import CoreData

class DBHelper
{
    func getTableName(tableClass: Any.Type) -> String {
        return String(describing: tableClass).components(separatedBy: ".").last! as String
    }
    
    func select<T:NSManagedObject>(id: NSManagedObjectID) -> T?
    {
        let item = self.managedObjectContext.object(with: id)
        if item is T
        {
            return item as? T
        }
        else
        {
            return nil
        }
    }
    
    func selectOrCreate<T:NSManagedObject>(whereClause: String?, parameters: [AnyObject]?) -> T?
    {
        let items: [T] = select(whereClause: whereClause, parameters: parameters)
        if (items.isEmpty)
        {
            let db = DBHelper()
            var _: T = create()
            db.save()
            return selectOrCreate(whereClause: whereClause, parameters: parameters)
        }
        return items[0]
    }
    
    func selectSingle<T:NSManagedObject>(whereClause: String?, parameters: [AnyObject]?) -> T?
    {
        let items: [T] = select(whereClause: whereClause, parameters: parameters)
        if (items.isEmpty)
        {
            return nil
        }
        return items[0]
    }
    
    func select<T:NSManagedObject>(whereClause: String?, parameters: [AnyObject]?) -> [T]
    {
        var result: [T] = []
        let tableName = getTableName(tableClass: T.self)
        
        let moc = self.managedObjectContext
        let itemsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        if whereClause.isEmpty == false && whereClause != ""
        {
            itemsFetch.predicate = NSPredicate(format: whereClause!, argumentArray: parameters)
        }
        
        do {
            result = try moc.fetch(itemsFetch) as! [T]
        } catch {
            fatalError("Failed to fetch \(tableName): \(error)")
        }
        
        return result
    }
    
    func select<T:NSManagedObject>() -> [T]
    {
        return select(whereClause: nil, parameters: [])
    }
    
    func create<T:NSManagedObject>() -> T {
        let tableName = getTableName(tableClass: T.self)
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: tableName, into: self.managedObjectContext) as! T
//        if newItem is BaseEntity
//        {
//            (newItem as! BaseEntity).createddate = NSDate().timeIntervalSinceReferenceDate
//            (newItem as! BaseEntity).modifieddate = NSDate().timeIntervalSinceReferenceDate
//        }
        
        return newItem
    }
    
    func delete<T:NSManagedObject>(item:T) {
        self.managedObjectContext.delete(item)
    }
    
    func save(){
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Oneworks.Carfix2" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Carfix", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        //let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CarfixDB.sqlite")
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CarfixDB.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
}
