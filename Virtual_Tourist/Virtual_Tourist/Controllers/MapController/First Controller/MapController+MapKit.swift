//
//  MapController+MapKit.swift
//  Virtual_Tourist
//
//  Created by admin on 2/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //            pinView?.clusteringIdentifier = "identifier"
            pinView?.displayPriority = .defaultHigh
            pinView!.canShowCallout = true
            pinView!.tintColor = .blue
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    func placeAnnotation(location: CLLocationCoordinate2D?){
        let annotation = MKPointAnnotation()
        annotation.title = "Hello World" //Doesn't show when 'didSelect' function is utilized by app
        
        if let coordinate = location {
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.mapType = .standard
            //            mapView.setCenter(coordinate, animated: true)
        } else {
            print("Unable to obtain coordinate from delegate")
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("pin tapped")
        UIApplication.shared.open(URL(string: "https://www.google.com")!)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        navigationController?.pushViewController(ShowingPicsController(), animated: true)
    }
}
