//
//  EXTENSIONS.swift
//  Virtual_Tourist
//
//  Created by admin on 3/4/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

extension Pin: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        let latDegrees = CLLocationDegrees(latitude)
        let longDegrees = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
    }
    
    //var backGroundContext: NSManagedObjectContext!
    public func movePin(coordinate: CLLocationCoordinate2D, viewContext: NSManagedObjectContext){
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.pageNumber = 1
        self.photoCount = 0
        try? viewContext.save()
    }

    //Executes at Pin Creation
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        pageNumber = 1
        photoCount = 0
    }
}

