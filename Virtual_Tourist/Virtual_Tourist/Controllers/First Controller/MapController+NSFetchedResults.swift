//
//  MapController+NSFetchedResults.swift
//  Virtual_Tourist
//
//  Created by admin on 3/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData


extension MapController {
    
    func setupFetchController(){
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        myFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: dataController.viewContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        do {
            try myFetchController.performFetch()
        } catch {
            fatalError("Unable to setup Fetch Controller: \n\(error)")
        }
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
            let newPin = anObject as? Pin
            mapView.annotations.forEach{
                let coordinate = $0.coordinate
                if newPin?.longitude == coordinate.longitude && newPin?.latitude == coordinate.latitude {
                    mapView.removeAnnotation($0)
                }
            }
        case .insert:
            guard let newPin = anObject as? Pin else {return}
            let newAnnotation = CustomAnnotation(lat: newPin.latitude, lon: newPin.longitude)
            mapView.addAnnotation(newAnnotation)
            print("ADD-refresh ---- * INSIDE MAP-CONTROLLER * ")
            self.delegate?.refresh()
        case .update:
            print("UPDATE-refresh ---- * INSIDE MAP-CONTROLLER * ")
            self.delegate?.refresh()
        default:
            break
        }
    }
}
