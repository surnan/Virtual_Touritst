//
//  MapController+Gestures.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData



extension MapController {
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state != .ended {
            let touchLocation = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
            let newPin = addNewPin(locationCoordinate)
//            _ = FlickrClient.getAllPhotoURLs(currentPin: newPin, fetchCount: fetchCount, completion: handleGetAllPhotoURLs(pin:urls:error:))
            
            _ = FlickrClient.getAllPhotoURLsNEXT(currentPin: newPin, getNext: false, fetchCount: fetchCount, completion: handleGetAllPhotoURLs(pin:urls:error:))
            _ = FlickrClient.getAllPhotoURLsNEXT(currentPin: newPin, getNext: true, fetchCount: fetchCount, completion: handleGetAllPhotoURLsNEXT(pin:urls:error:))
            return
        }
    }
    

//    func addNewPin(_ locationCoordinate: CLLocationCoordinate2D)->Pin {
//        let pinToAdd = Pin(context: dataController.viewContext)
//        pinToAdd.latitude = locationCoordinate.latitude
//        pinToAdd.longitude = locationCoordinate.longitude
//        pinToAdd.pageNumber = 1
//        pinToAdd.photoCount = 0
//        try? dataController.viewContext.save()
//        return pinToAdd
//    }
    
    func handleGetAllPhotoURLsNEXT(pin: Pin, urls: [URL], error: Error?){
        
        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NextPinURLs")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try dataController.viewContext.execute(request)
            try dataController.viewContext.save()   //maybe it should be commented
        } catch {
            print ("There was an error")
        }
        
        
        
        if let error = error {
            print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
            return
        }
        
        let objectID = pin.objectID
        let backgroundPin = dataController.backGroundContext.object(with: objectID) as! Pin
        
        urls.forEach{
            let nextPinURLToAdd = NextPinURLs(context: backgroundContext)
            nextPinURLToAdd.urlString = $0.absoluteString
            nextPinURLToAdd.pin = backgroundPin
        }
        
        try? backgroundContext.save()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func handleGetAllPhotoURLs(pin: Pin, urls: [URL], error: Error?){
        let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
        
        if let error = error {
            print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
            return
        }
        
        
        let pinId = pin.objectID
        
        
        backgroundContext.perform {
            let backgroundPin = backgroundContext.object(with: pinId) as! Pin
            backgroundPin.urlCount = Int32(urls.count)
            try? backgroundContext.save()
        }
        
        for (index, currentURL) in urls.enumerated() {
            URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                guard let imageData = imageData else {return}
                connectPhotoAndPin(dataController: self.dataController, currentPin:  pin , data: imageData, urlString: currentURL.absoluteString, index: index)
            }).resume()
        }
    }
    
    
    @objc func handleDeleteALLButton(){
        mapView.removeAnnotations(mapView.annotations)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try dataController.viewContext.execute(request)
            try dataController.viewContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    @objc func handleEditButton(sender: UIButton){
        sender.isSelected = !sender.isSelected
        toggleBottomUILabel(show: sender.isSelected)
    }
    
    func toggleBottomUILabel(show: Bool){
        show ? showBottomlabel() : hideBottomlabel()
        UIView.animate(withDuration: 0.15,
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)
    }
}
