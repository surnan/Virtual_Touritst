//
//  MapCollectionViewController+Map.swift
//  Virtual_Tourist
//
//  Created by admin on 3/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData


extension CollectionMapViewController {
    
    func setupMapView() {
        myMapView.addAnnotation(firstAnnotation)
        myMapView.centerCoordinate = firstAnnotation.coordinate
        //Setting up Zoom
        let noLocation = firstAnnotation.coordinate
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: mapRegionDistanceValue, longitudinalMeters: mapRegionDistanceValue)
        myMapView.setRegion(viewRegion, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.displayPriority = .defaultHigh
            pinView!.canShowCallout = true
            pinView!.tintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        print("\n\nAnnotations.Count ---> \(annotations.count)")
//        guard var _stringToURL = view.annotation?.subtitle as? String else {
//            UIApplication.shared.open(URL(string: "https://www.google.com")!)     //MediaURL = empty.  Load google
//            return
//        }
//        let backupURL = URL(string: "https://www.google.com/search?q=" + _stringToURL)!  //URL is invalid, convert string to google search query
//        if _stringToURL._isValidURL {
//            _stringToURL = _stringToURL._prependHTTPifNeeded()
//            let url = URL(string: _stringToURL) ?? backupURL
//            UIApplication.shared.open(url)
//        } else {
//            UIApplication.shared.open(backupURL)
//        }
//    }
    
    
}
