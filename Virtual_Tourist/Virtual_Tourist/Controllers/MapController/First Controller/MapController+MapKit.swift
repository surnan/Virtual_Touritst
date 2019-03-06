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


class CustomAnnotationView: MKPinAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        pinTintColor = .black
        isDraggable = true
        animatesDrop = true
        canShowCallout = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if tapDeletesPin {
            guard let annotationToRemove = view.annotation as? MyAnnotation else { return }
            let coord = annotationToRemove.coordinate
            getAllPins().forEach { (aPin) in
                if aPin.longitude == coord.longitude && aPin.latitude == coord.latitude {
                    dataController.viewContext.delete(aPin)
                    try? dataController.viewContext.save()
                }
            }
            return
        }
        /*
        guard let location = self.selectedAnnotation?.coordinate else {
            print("Annotation selected had coordingate = nil")
            return
        }
        let lon = Double(location.longitude)
        let lat = Double(location.latitude)
                _ = FlickrClient.searchPhotos(latitude: lat, longitude: lon, count: 10, completion: handleFlickrClientSearchPhotos(pictureList:error:))
         navigationController?.pushViewController(FlickrCollectionController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
         */
    }
    
    
    /*
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
    */
    

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        
        guard let myAnnotation = view.annotation else {return}
        
        let coord = myAnnotation.coordinate
        print("Lat = \(coord.latitude)  ...   Lon = \(coord.longitude)")
        
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
            
            getAllPins().forEach { (aPin) in
                if aPin.longitude == oldCoordinates?.longitude && aPin.latitude == oldCoordinates?.latitude {
                    aPin.latitude = coord.latitude
                    aPin.longitude = coord.longitude
                    
                    try? dataController.viewContext.save()
                    oldCoordinates = nil
                }
            }
            
        case .canceling:
            if let view = view as? MKPinAnnotationView {view.pinTintColor = UIColor.red}
        default: break
        }
    }
    
    /*
    func handleFlickrClientGetPhotoURL(url: URL?, error: Error?){
                print("hello world")
                if let myURL = url {
                    downloadImageFromURL(myURL: myURL) {(data, error) in
                        if let myImage = data {
                            self.imageArray.append(myImage)
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
    */
    
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
    
    
    func placeAnnotation(pin: Pin?) {
        let newAnnotation = MKPointAnnotation()
        guard let lat = pin?.latitude, let lon = pin?.longitude else {return}
        let myNewAnnotation = MyAnnotation(lat: lat, lon: lon)
        newAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        mapView.addAnnotation(myNewAnnotation)
    }
}





class MyAnnotation: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    dynamic var title: String?
    dynamic var subtitle: String?
    
    //    var coordinate: CLLocationCoordinate2D
    //    var title: String?
    //    var subtitle: String?
    
    init(lat: Double, lon: Double){
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        super.init()
    }
}
