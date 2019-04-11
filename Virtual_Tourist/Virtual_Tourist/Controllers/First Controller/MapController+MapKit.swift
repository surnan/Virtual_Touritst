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
            previousPinID = getCorrespondingPin(annotation: myAnnotation)?.objectID
        case .ending:
            view.dragState = .none

            if let view = view as? MKPinAnnotationView {view.pinTintColor = UIColor.black}
            guard let _previousPin = previousPinID, let newPin = dataController.viewContext.object(with: _previousPin) as? Pin  else {return}

            
            let fetch222 = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            fetch222.predicate = NSPredicate(format: "pin = %@", argumentArray: [newPin])
            let request = NSBatchDeleteRequest(fetchRequest: fetch222)
            _ = try? dataController.viewContext.execute(request)

            newPin.movePin(coordinate: myAnnotation.coordinate, viewContext: dataController.viewContext)
            previousPinID = nil
            
//            FlickrClient.getAllPhotoURLs(currentPin: newPin, fetchCount: fetchCount, completion: handleGetAllPhotoURLs(pin:urls:error:))
            _ = FlickrClient.getAllPhotoURLsNEXT(currentPin: newPin, samePage: false, fetchCount: fetchCount, completion: handleGetAllPhotoURLs(pin:urls:error:))
            _ = FlickrClient.getAllPhotoURLsNEXT(currentPin: newPin, samePage: true, fetchCount: fetchCount, completion: handleGetAllPhotoURLsNEXT(pin:urls:error:))
            

        case .canceling:
            if let view = view as? MKPinAnnotationView {view.pinTintColor = UIColor.black}
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? CustomAnnotation,
            let desiredPin = getCorrespondingPin(annotation: selectedAnnotation) else {
                return
        }
        
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
        let newController = CollectionMapViewController()
        newController.dataController = self.dataController
        newController.pin = apin
        self.delegate = newController
        print("lat/lon ---> \(apin.coordinate)")
        navigationController?.pushViewController(newController, animated: true)
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
