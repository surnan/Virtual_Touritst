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

//extension Pin: MKAnnotation {
//    public var coordinate: CLLocationCoordinate2D {
//        let latDegrees = CLLocationDegrees(latitude)
//        let longDegrees = CLLocationDegrees(longitude)
//        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
//    }
//}


extension Pin {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        pageNumber = 1
    }
    
//    public func getPageNumber()-> Int32 {
//        return pageNumber
//    }
}
