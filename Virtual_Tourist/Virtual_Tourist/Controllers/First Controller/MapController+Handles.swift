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
//            downloadNearbyPhotosToPin(dataController: dataController, currentPin: newPin, fetchCount: fetchCount)
            
            let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
            let currentPinID = newPin.objectID
            
            FlickrClient.getAllPhotoURLs(currentPin: newPin, fetchCount: fetchCount) { (urls, error) in //+1
                if let error = error {
                    print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
                    return
                }
                backgroundContext.perform { //+2
                    let backgroundPin = backgroundContext.object(with: currentPinID) as! Pin
                    backgroundPin.urlCount = Int32(urls.count)
                    try? backgroundContext.save()
                }   //-2
                
                
                for (index, currentURL) in urls.enumerated() {
                    //            print("URL inside loop --> \(currentURL)")
                    URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                        //                print("currentURL = \(currentURL)")
                        guard let imageData = imageData else {return}
                        connectPhotoAndPin(dataController: self.dataController, currentPin:  newPin , data: imageData, urlString: currentURL.absoluteString, index: index)
                    }).resume()
                }
            }
            
            
            
            
            
            
            return
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
