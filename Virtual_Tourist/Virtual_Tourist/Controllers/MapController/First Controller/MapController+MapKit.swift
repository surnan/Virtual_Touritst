//
//  MapController+MapKit.swift
//  Virtual_Tourist
//
//  Created by admin on 2/27/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData


extension MapController: MKMapViewDelegate {
    
    func placeAnnotation(pin: Pin?) {
        let newAnnotation = MKPointAnnotation()
        guard let lat = pin?.latitude, let lon = pin?.longitude else {return}
        let myNewAnnotation = CustomAnnotation(lat: lat, lon: lon)
        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        mapView.addAnnotation(myNewAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let myAnnotation = view.annotation else {return}
        let coord = myAnnotation.coordinate
        switch (newState) {
        case .starting:
            view.dragState = .dragging
            if let view = view as? MKPinAnnotationView {
                view.pinTintColor = UIColor.green
                oldCoordinates = coord
            }
        case .ending:
            view.dragState = .none
            if let view = view as? MKPinAnnotationView {view.pinTintColor = UIColor.red}
            editExistingPin(coord)
        case .canceling:
            if let view = view as? MKPinAnnotationView {view.pinTintColor = UIColor.red}
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if tapDeletesPin {
            guard let annotationToRemove = view.annotation as? CustomAnnotation else { return }
            let coord = annotationToRemove.coordinate
            getAllPins().forEach { (aPin) in
                if aPin.longitude == coord.longitude && aPin.latitude == coord.latitude {
                    dataController.viewContext.delete(aPin)
                    try? dataController.viewContext.save()
                }
            }
            return
        }
        
        guard let annotationToCheck = view.annotation as? CustomAnnotation else { return }
        let location = annotationToCheck.coordinate
        let lon = Double(location.longitude)
        let lat = Double(location.latitude)
        
        let newController = FlickrCollectionController(collectionViewLayout: UICollectionViewFlowLayout())
        
        var currentPin: Pin?
        self.getAllPins().forEach { (aPin) in
            if aPin.longitude == lon && aPin.latitude == lat {
                currentPin = aPin
            }
        }
        
        newController.dataController = dataController
        newController.Pin = currentPin!
        
        
        let tempPhoto = Photo(context: dataController.viewContext)
        
        _ = FlickrClient.searchNearbyForPhotos(latitude: lat, longitude: lon, count: 3, completion: { (data, error) in
            data.forEach{ (element) in
                element.forEach{
                    FlickrClient.getPhotoURL(photoID: $0.key, secret: $0.value, completion: { (urlString, error) in
                        guard let newURLString = urlString, let url = URL(string: newURLString) else {
                            return
                        }
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, resp, err) in
                            if let data = data {
                                tempPhoto.image = data
                                tempPhoto.index = 347.855
                                tempPhoto.pin = currentPin
                                tempPhoto.urlString = urlString!
                                try? self.dataController.viewContext.save()
                                self.navigationController?.pushViewController(newController, animated: true)
                            }
                        }).resume()
                    })
                }
            }
        })
    }
}
