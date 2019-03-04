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

extension Pin: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        let latDegrees = CLLocationDegrees(latitude)
        let longDegrees = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
    }
}



/*
 extension Point: MKAnnotation {
 public var coordinate: CLLocationCoordinate2D {
 // latitude and longitude are optional NSNumbers
 guard let latitude = latitude, let longitude = longitude else {
 return kCLLocationCoordinate2DInvalid
 }
 
 let latDegrees = CLLocationDegrees(latitude.doubleValue)
 let longDegrees = CLLocationDegrees(longitude.doubleValue)
 return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
 }
 }
 */

