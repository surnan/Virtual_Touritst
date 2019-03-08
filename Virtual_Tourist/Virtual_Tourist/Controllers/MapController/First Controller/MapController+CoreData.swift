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
        guard let pins = myFetchController.fetchedObjects else {
            return []
        }
        return pins
    }
    
    func matchPinToLocation(latitude: Double, longitude: Double) -> Pin?{
        let context = dataController.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let predicate = NSPredicate(format: "(latitude = %@) AND (longitude = %@)", argumentArray: [latitude, longitude])
        fetch.predicate = predicate
        do {
            let result = try context.fetch(fetch)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "latitude") as! Double)
                print(data.value(forKey: "longitude") as! Double)
                let myPin = data as! Pin
                return myPin
            }
        } catch {
            return nil
        }
        return nil
    }
    
    
//    func matchPinToLocation2(latitude: Double, longitude: Double) -> Pin?{
//        let context = dataController.viewContext
//        let fetch = NSFetchRequest<Pin>(entityName: "Pin")
//        let predicate = NSPredicate(format: "latitude = %@", argumentArray: [latitude])
//        fetch.predicate = predicate
//        do {
//            let result = try context.fetch(fetch)
//
//            }
//        } catch {
//            return nil
//        }
//        return nil
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func addNewPin(_ locationCoordinate: CLLocationCoordinate2D) {
        let pinToAdd = Pin(context: dataController.viewContext)
        pinToAdd.latitude = locationCoordinate.latitude
        pinToAdd.longitude = locationCoordinate.longitude
        //   let index = myFetchController.fetchedObjects?.count ?? 0
        //   pinToAdd.pageNumber = Int32(index)
        try? dataController.viewContext.save()
    }
    
    func editExistingPin(_ coord: CLLocationCoordinate2D) {
        getAllPins().forEach { (aPin) in
            if aPin.longitude == oldCoordinates?.longitude && aPin.latitude == oldCoordinates?.latitude {
                aPin.latitude = coord.latitude
                aPin.longitude = coord.longitude
                try? dataController.viewContext.save()
                oldCoordinates = nil
            }
        }
    }
}

/*
 func matchPinToLocation(latitude: Double, longitude: Double) -> Pin?{
 let context = dataController.viewContext
 let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
 let predicate = NSPredicate(format: "latitude = %@", argumentArray: [latitude])
 fetch.predicate = predicate
 do {
 let result = try context.fetch(fetch)
 for data in result as! [NSManagedObject] {
 print(data.value(forKey: "latitude") as! Double)
 print(data.value(forKey: "longitude") as! Double)
 let myPin = data as! Pin
 return myPin
 }
 } catch {
 return nil
 }
 return nil
 }
 */
