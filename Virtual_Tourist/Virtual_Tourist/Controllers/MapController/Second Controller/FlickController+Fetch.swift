//
//  FlickController+Fetch.swift
//  Virtual_Tourist
//
//  Created by admin on 3/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData


extension FlickrCollectionController {

func setupFetchController(){
//    let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
//    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
//    myFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                                   managedObjectContext: dataController.viewContext,
//                                                   sectionNameKeyPath: nil,
//                                                   cacheName: nil)
//    do {
//        try myFetchController.performFetch()
//    } catch {
//        fatalError("Unable to setup Fetch Controller: \n\(error)")
//    }
}

func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("")
}

func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("")
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .delete:
        print("")
    case .insert:
        print("")
    case .update:
        print("")
    default:
        break
    }
}
}
