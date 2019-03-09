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
    
    func addNewPin(_ locationCoordinate: CLLocationCoordinate2D) {
        let pinToAdd = Pin(context: dataController.viewContext)
        pinToAdd.latitude = locationCoordinate.latitude
        pinToAdd.longitude = locationCoordinate.longitude
        try? dataController.viewContext.save()
    }
    
    func editExistingPin2(_ annotation: MKAnnotation) {
        let coord = annotation.coordinate   //class-wide variable
        getAllPins().forEach { (aPin) in
            if aPin.longitude == oldCoordinates?.longitude && aPin.latitude == oldCoordinates?.latitude {
                aPin.latitude = coord.latitude
                aPin.longitude = coord.longitude
                try? dataController.viewContext.save()
                oldCoordinates = nil
            }
        }
    }
    
    func editExistingPin3(_ annotation: MKAnnotation) {
        let coord = annotation.coordinate   //class-wide variable

        
        
        
        var _pinToEdit = getCorrespondingPin(annotation: annotation as! CustomAnnotation)
        
        guard let pinToEdit = _pinToEdit else {return}
        
        
        
        pinToEdit.latitude = annotation.coordinate.latitude
        pinToEdit.longitude = annotation.coordinate.longitude
        
        try? dataController.viewContext.save()
        
//        getAllPins().forEach { (aPin) in
//            if aPin.longitude == oldCoordinates?.longitude && aPin.latitude == oldCoordinates?.latitude {
//                aPin.latitude = coord.latitude
//                aPin.longitude = coord.longitude
//                try? dataController.viewContext.save()
//                oldCoordinates = nil
//            }
//        }
    }
    
    func getCorrespondingPin(annotation: CustomAnnotation) -> Pin?{
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
    
}



















//CLLocationCoordinate2D <--- works
//    func matchPinToLocation2(location: CLLocationCoordinate2D) -> Pin?{
//        let context = dataController.viewContext
//        let fetch = NSFetchRequest<Pin>(entityName: "Pin")
//        let predicate = NSPredicate(format: "(latitude = %@) AND (longitude = %@)", argumentArray: [location.latitude, location.longitude])
//        fetch.predicate = predicate
//        do {
//            let result = try context.fetch(fetch)
//            return result.first
//        } catch {
//            return nil
//        }
//    }
