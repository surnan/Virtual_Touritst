//
//  DataController.swift
//  Virtual_Tourist
//
//  Created by admin on 3/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData


class DataController {
    
    let persistentContainer: NSPersistentContainer
    init(modelName: String) {
        persistentContainer = NSPersistentContainer.init(name: modelName)
        
        
        
        /*
         viewContext = Main Queue
         
         ALL TASKS SHOULD BE WRAPPED IN "PERFORM"
         
        //Allows parallel and performs tasks on appropriate Queues
        persistentContainer.performBackgroundTask { (context) in
            try? context.save()
        }
        
         //Asynchronously on the appropriate queue for that context
        viewContext.perform {
            <#code#>
        }
        
        //Synchronously on the correct Queue
        viewContext.performAndWait {
            <#code#>
        }
        */
        
        
        
    }
    
    var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
    var backGroundContext: NSManagedObjectContext!
    
    func configureContexts(){
        
        backGroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backGroundContext.automaticallyMergesChangesFromParent = true
        //In this app, all saves are through background, so there should be conflicts.
        backGroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump    //background gets priority @ conflict
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (()-> Void)? = nil) {
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            guard error == nil else {
                fatalError((error?.localizedDescription)!)
            }
        }
        self.configureContexts()
        completion?() //Show loading screen while core data loads
    }
}



/*
 class DataController {
 
 let persistentContainer: NSPersistentContainer
 init(modelName: String) {
 persistentContainer = NSPersistentContainer.init(name: modelName)
 }
 
 var viewContext: NSManagedObjectContext { return persistentContainer.viewContext }
 var backGroundContext: NSManagedObjectContext!
 
 func configureContexts(){
 backGroundContext = persistentContainer.newBackgroundContext()
 viewContext.automaticallyMergesChangesFromParent = true
 backGroundContext.automaticallyMergesChangesFromParent = true
 backGroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump    //background gets priority @ conflict
 viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
 }
 
 func load(completion: (()-> Void)? = nil) {
 persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
 guard error == nil else {
 fatalError((error?.localizedDescription)!)
 }
 }
 self.configureContexts()
 completion?() //Show loading screen while core data loads
 }
 }
 */
