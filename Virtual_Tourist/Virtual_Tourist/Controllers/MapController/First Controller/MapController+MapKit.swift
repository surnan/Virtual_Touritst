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

        guard let selectedAnnotation = view.annotation as? CustomAnnotation else { return }
        let coord =  selectedAnnotation.coordinate
        
        if tapDeletesPin {
            if let pintToDelete = matchPinToLocation2(location: coord) {
                dataController.viewContext.delete(pintToDelete)
                try? dataController.viewContext.save()
            }
            return
        }
        
        
        let newController = FlickrCollectionController(collectionViewLayout: UICollectionViewFlowLayout())
        _ = FlickrClient.searchNearbyForPhotos(latitude: coord.latitude, longitude: coord.longitude, count: 3, completion: { (data, err) in
            guard let apin = self.matchPinToLocation2(location: coord) else {return}
            newController.dataController = self.dataController
            newController.pin = apin
            self.delegate = newController
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(newController, animated: true)
            }
            
            data.forEach({ (photo_secret) in
                photo_secret.forEach{
                    FlickrClient.getPhotoURL(photoID: $0.key, secret: $0.value, completion: { (urlString, err) in
                        guard let _urlString = urlString, let url = URL(string: _urlString) else {return}
                        print("url = \(url)")
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            guard let data = data else {return}
                            self.connectPhotoAndPin(dataController: self.dataController, pin:  apin , data: data, urlString: _urlString)
                            
                            
                            
                        }).resume()
                    })
                }
            })
//            DispatchQueue.main.async {
//                newController.photoID_Secret_Dict = data
//                self.navigationController?.pushViewController(newController, animated: true)
//            }
        })
    }
    
    
    func connectPhotoAndPin(dataController: DataController, pin: Pin, data: Data, urlString: String){
        let tempPhoto = Photo(context: dataController.viewContext)
        tempPhoto.imageData = data
        tempPhoto.urlString = urlString
        tempPhoto.index = Int32(718212)
        tempPhoto.pin = pin
        let testImage = UIImage(data: tempPhoto.imageData!)
        try? dataController.viewContext.save()
    }
}




func checkIfRefreshNeeded(){
    
}



//GLOBAL FUNCTIONS

func getCurrentViewController(_ vc: UIViewController) -> UIViewController? {
    if let pvc = vc.presentedViewController {
        return getCurrentViewController(pvc)
    }
    else if let svc = vc as? UISplitViewController, svc.viewControllers.count > 0 {
        return getCurrentViewController(svc.viewControllers.last!)
    }
    else if let nc = vc as? UINavigationController, nc.viewControllers.count > 0 {
        return getCurrentViewController(nc.topViewController!)
    }
    else if let tbc = vc as? UITabBarController {
        if let svc = tbc.selectedViewController {
            return getCurrentViewController(svc)
        }
    }
    return vc
}


//EXTENSIONS
extension UIApplication {
    var visibleViewController : UIViewController? {
        return keyWindow?.rootViewController?.topViewController
    }
}

extension UIViewController {
    fileprivate var topViewController: UIViewController {
        switch self {
        case is UINavigationController:
            return (self as! UINavigationController).visibleViewController?.topViewController ?? self
        case is UITabBarController:
            return (self as! UITabBarController).selectedViewController?.topViewController ?? self
        default:
            return presentedViewController?.topViewController ?? self
        }
    }
}
