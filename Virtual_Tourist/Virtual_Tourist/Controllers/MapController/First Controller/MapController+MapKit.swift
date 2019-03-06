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
        
        
        let myImageArray = imageArray
        
        guard let annotationToRemove = view.annotation as? CustomAnnotation else { return }
        let location = annotationToRemove.coordinate
        let lon = Double(location.longitude)
        let lat = Double(location.latitude)
        //        _ = FlickrClient.searchPhotos(latitude: lat, longitude: lon, count: 10, completion: handleFlickrClientSearchPhotos(pictureList:error:))
        //        navigationController?.pushViewController(FlickrCollectionController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
        
        
        _ = FlickrClient.searchPhotos(latitude: lat, longitude: lon, count: 5, completion: { (data, err) in
            
            data.forEach({ (temp) in
                temp.forEach{
                    FlickrClient.getPhotoURL(photoID: $0.key, secret: $0.value, completion: { (url, err) in
                        if let myURL = url {
                            self.downloadImageFromURL(myURL: myURL) {(data, error) in
                                if let myImage = data {
                                    imageArray.append(myImage)
                                    imageArray.append(myImage)
                                    print("BREAK HERE")
                                } else {
                                    print("Unable to get Photo from downloadImageFromURL")
                                }
                            }
                        } else {
                            print("Error inside closure from GETPHOTOURL: \(String(describing: err))")
                        }
                    })
                }
            })
            self.navigationController?.pushViewController(FlickrCollectionController(), animated: true)
        })
    }
}
