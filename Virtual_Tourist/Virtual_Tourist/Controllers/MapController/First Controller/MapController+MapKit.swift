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
    

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if deletePhase {
            guard let annotationToRemove = view.annotation as? MKPointAnnotation else {return}
            let coord = annotationToRemove.coordinate
            getAllPins().forEach { (aPin) in
                if aPin.longitude == coord.longitude && aPin.latitude == coord.latitude {
                    dataController.viewContext.delete(aPin)
                    try? dataController.viewContext.save()
                    mapView.removeAnnotation(aPin)
                }
            }
        } else {
            self.selectedAnnotation = view.annotation as? MKPointAnnotation
            guard let location = self.selectedAnnotation?.coordinate else {
                print("Annotation selected had coordingate = nil")
                return
            }
            let lon = Double(location.longitude)
            let lat = Double(location.latitude)
            _ = FlickrClient.searchPhotos(latitude: lat, longitude: lon, count: 10, completion: handleFlickrClientSearchPhotos(pictureList:error:))
//      GOOD -      navigationController?.pushViewController(FlickrCollectionController(collectionViewLayout: UICollectionViewFlowLayout()), animated: true)
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
//        print("hello world")
//        if let myURL = url {
//            downloadImageFromURL(myURL: myURL) {(data, error) in
//                if let myImage = data {
////                    self?.imageArray.append(myImage)
////                    imageArray.append(myImage)
//                    print("BREAK HERE")
//                } else {
//                    print("Unable to get Photo from downloadImageFromURL")
//                }
//            }
//        } else {
//            print("Error inside closure from GETPHOTOURL: \(String(describing: error))")
//        }
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

//: NSFetchedResultsControllerDelegate
extension MapController {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("test")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("test")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            break
//            let temp = mapView.annotations[(indexPath?.row)!]
//            mapView.removeAnnotation(temp)
        case .insert:
             guard let newPin = anObject as? Pin else {return}
             let newAnnotation = MyAnnotation(lat: newPin.latitude, lon: newPin.longitude)
             mapView.addAnnotation(newAnnotation)
            print("Going to Add Annotation")
            break
        default:
            break
        }
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
