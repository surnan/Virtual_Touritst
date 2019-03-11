//
//  MapController+CoreData.swift
//  Virtual_Tourist
//
//  Created by admin on 3/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension MapController {
    func getAllPins()->[Pin]{
        return myFetchController.fetchedObjects ?? []
    }
    
    func addNewPin(_ locationCoordinate: CLLocationCoordinate2D)->Pin {
        let pinToAdd = Pin(context: dataController.viewContext)
        pinToAdd.latitude = locationCoordinate.latitude
        pinToAdd.longitude = locationCoordinate.longitude
        pinToAdd.pageNumber = 1
        pinToAdd.photoCount = 0
        try? dataController.viewContext.save()
        return pinToAdd
    }
    
//    func editExistingPin2(_ annotation: MKAnnotation) {
//        let coord = annotation.coordinate   //class-wide variable
//        getAllPins().forEach { (aPin) in
//            if aPin.longitude == oldCoordinates?.longitude && aPin.latitude == oldCoordinates?.latitude {
//                aPin.latitude = coord.latitude
//                aPin.longitude = coord.longitude
//                try? dataController.viewContext.save()
//                oldCoordinates = nil
//            }
//        }
//    }
//
//    func editExistingPin3(_ annotation: MKAnnotation) {
//        guard let oldCoordinates = oldCoordinates, let pinToEdit = getCorrespondingPin(coordinate: oldCoordinates) else {return}
//        pinToEdit.latitude = annotation.coordinate.latitude
//        pinToEdit.longitude = annotation.coordinate.longitude
//        try? dataController.viewContext.save()
//    }
    
    func getCorrespondingPin(annotation: MKAnnotation) -> Pin?{
        let location = annotation.coordinate
        let context = dataController.viewContext
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        let predicate = NSPredicate(format: "(latitude = %@) AND (longitude = %@)", argumentArray: [location.latitude, location.longitude])
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            return nil
        }
    }
    
    
    func getCorrespondingPin(coordinate: CLLocationCoordinate2D) -> Pin?{
        let location = coordinate
        let context = dataController.viewContext
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        let predicate = NSPredicate(format: "(latitude = %@) AND (longitude = %@)", argumentArray: [location.latitude, location.longitude])
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            return nil
        }
    }
}
