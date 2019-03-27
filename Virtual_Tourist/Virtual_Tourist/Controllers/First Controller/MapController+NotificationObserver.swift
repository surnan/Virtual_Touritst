//
//  MapController+NotificationObserver.swift
//  Virtual_Tourist
//
//  Created by admin on 3/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData



extension MapController {
    func addSaveNotifcationObserver(){
        removeSaveNotificationObserver()
        saveObserverToken = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: dataController.viewContext, queue: nil, using: handleSaveNotification(notification:))
    }
    
    func removeSaveNotificationObserver(){
        if let token = saveObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func handleSaveNotification(notification: Notification){
        DispatchQueue.main.async {
            //            print("Core Data Updated and UI upgraded through NSFetchResults --> 'didChange anObject'  ")
        }
    }
}
