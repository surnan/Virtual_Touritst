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
    
    func addNewPin(_ locationCoordinate: CLLocationCoordinate2D) {
        let pinToAdd = Pin(context: dataController.viewContext)
        pinToAdd.latitude = locationCoordinate.latitude
        pinToAdd.longitude = locationCoordinate.longitude
        let index = myFetchController.fetchedObjects?.count ?? 0
        pinToAdd.index = Int16(index)
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
