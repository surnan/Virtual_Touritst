//
//  MapController+Entities.swift
//  Virtual_Tourist
//
//  Created by admin on 3/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


extension MapController {
    func getAllPins()->[Pin]{
        guard let pins = myFetchController.fetchedObjects else {
            return []
        }
        return pins
    }
}
