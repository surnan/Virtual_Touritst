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



/*
 newPin.photoCount = Int32(urls.count)
 newPin.page = 1 //<------ RESET TO PAGE ONE
 try? self.dataController.viewContext.save()
 
 urls.forEach({ (currentURL) in
 print("URL inside loop --> \(currentURL)")
 URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
 print("currentURL = \(currentURL)")
 guard let imageData = imageData else {return}
 self.connectPhotoAndPin(dataController: self.dataController, pin:  newPin , data: imageData, urlString: currentURL.absoluteString)
 }).resume()
 })
 */

extension MapController: MKMapViewDelegate {
    
    func placeAnnotation(pin: Pin?) {
        guard let lat = pin?.latitude, let lon = pin?.longitude else {return}
        let myNewAnnotation = CustomAnnotation(lat: lat, lon: lon)
        mapView.addAnnotation(myNewAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let myAnnotation = view.annotation else {return}
        switch (newState) {
        case .starting:
            view.dragState = .dragging
            if let view = view as? MKPinAnnotationView {
                view.pinTintColor = UIColor.green
            }
            oldCoordinates = myAnnotation.coordinate //class-wide variable
        case .ending:
            view.dragState = .none
            if let view = view as? MKPinAnnotationView {view.pinTintColor = UIColor.red}

            
            
            guard let deezCoordinates = oldCoordinates else {return}
            guard let pinToChange = getCorrespondingPin(coordinate: deezCoordinates) else {return}
            pinToChange.movePin(coordinate: myAnnotation.coordinate, viewContext: dataController.viewContext)
            
            var fetch222 = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            fetch222.predicate = NSPredicate(format: "pin = %@", argumentArray: [pinToChange])
            let request = NSBatchDeleteRequest(fetchRequest: fetch222)
            try? dataController.viewContext.execute(request)
            
            
            downloadPhotosAndLinkToPin(pinToChange)
            
            
            
        case .canceling:
            if let view = view as? MKPinAnnotationView {view.pinTintColor = UIColor.red}
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? CustomAnnotation, let desiredPin = getCorrespondingPin(annotation: selectedAnnotation) else {return}
        //1
        if tapDeletesPin {
                dataController.viewContext.delete(desiredPin)
                try? dataController.viewContext.save()
            return
        }
        //2
        PushToCollectionViewController(apin: desiredPin)
    }
    
    func PushToCollectionViewController(apin: Pin){
        let newController = FlickrCollectionController(collectionViewLayout: UICollectionViewFlowLayout())
        newController.dataController = self.dataController
        newController.pin = apin
        self.delegate = newController
        navigationController?.pushViewController(newController, animated: true)
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
