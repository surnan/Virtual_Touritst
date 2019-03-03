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
            pinView?.clusteringIdentifier = "identifier"
            //            pinView?.displayPriority = .defaultHigh
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
        if let coordinate = location {
            print("lat = \(coordinate.latitude)  ..... lon = \(coordinate.longitude)")
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        } else {
            print("Unable to obtain coordinates")
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if deletePhase {
            self.selectedAnnotation = view.annotation as? MKPointAnnotation
            mapView.removeAnnotation(view.annotation!)
        } else {
//            navigationController?.pushViewController(FlickrCollectionController(), animated: true)
            
            navigationController?.pushViewController(FlickrCollectionController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
            
            
            self.selectedAnnotation = view.annotation as? MKPointAnnotation
            guard let location = self.selectedAnnotation?.coordinate else {
                print("Annotation selected had coordingate = nil")
                return
            }
            
            let lon = Double(location.longitude)
            let lat = Double(location.latitude)
            
            _ = FlickrClient.searchPhotos(latitude: lat, longitude: lon, count: 10, completion: handleFlickrClientSearchPhotos(pictureList:error:))
        }
    }
    
    func handleFlickrClientSearchPhotos(pictureList: [[String: String]], error: Error?){
        if let err = error {
            print("Error in Handler: \(err)")
            return
        }
        pictureList.forEach { (temp) in
            temp.forEach{
                FlickrClient.getPhotoURL(photoID: $0.key, secret: $0.value, completion: handleFlickrClientGetPhotoURL(url:error:))
            }
        }
    }
    
    func handleFlickrClientGetPhotoURL(url: URL?, error: Error?){
        if let myURL = url {
            downloadImageFromURL(myURL: myURL) {[weak self] (data, error) in
                if let myImage = data {
//                    self?.imageArray.append(myImage)
                    imageArray.append(myImage)
                    print("BREAK HERE")
                } else {
                    print("Unable to get Photo from downloadImageFromURL")
                }
            }
        } else {
            print("Error inside closure from GETPHOTOURL: \(String(describing: error))")
        }
    }
    
    
    func downloadImageFromURL(myURL: URL, completion: @escaping (UIImage?, Error?)->Void){
        URLSession.shared.dataTask(with: myURL) {(data, response, error) in
            if let data = data, let tempImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(tempImage, nil)
                }
                return
            } else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            }.resume()
    }
}

