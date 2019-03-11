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
            downloadPhotosAndLinkToPin(newPin)
            return
        }
    }
    
 
    
    
    func downloadPhotosAndLinkToPin(_ newPin: Pin) {
        FlickrClient.searchNearbyPhotoData(currentPin: newPin, fetchCount: fetchCount) { (urls, error) in
            if let error = error {
                print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
                return
            }
            
            newPin.photoCount = Int32(urls.count)
            try? self.dataController.viewContext.save()
            
            urls.forEach({ (currentURL) in
                print("URL inside loop --> \(currentURL)")
                URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                    print("currentURL = \(currentURL)")
                    guard let imageData = imageData else {return}
                    self.connectPhotoAndPin(dataController: self.dataController, pin:  newPin , data: imageData, urlString: currentURL.absoluteString)
                }).resume()
            })
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
