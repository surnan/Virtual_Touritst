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

            print("\n\n\n=================== CURRENTCHECK IS HERE =================== \(sender.state)\n\n\n")
            
            if currentSearchTask != nil {
                return
            }

            
            let touchLocation = sender.location(in: self.mapView)
            let locationCoordinate = self.mapView.convert(touchLocation,toCoordinateFrom: self.mapView)
            let newPin = addNewPin(locationCoordinate)
            
            currentSearchTask = FlickrClient.searchNearbyPhotoData(currentPin: newPin, fetchCount: fetchCount) { (urls, error) in
                
                print("---------------------------------------------")
                
                if let error = error {
                    print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
                    return
                }
                
                newPin.photoCount = Int32(urls.count)
                try? self.dataController.viewContext.save()
                
                if newPin.photoCount == 0 {
                    self.currentSearchTask = nil
                    return
                }
                
                let loop = urls.count
                urls.forEach({ (currentURL) in
                    print("URL inside loop --> \(currentURL)")
                    URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                        print("currentURL = \(currentURL)")
                        guard let imageData = imageData else {return}
                        self.connectPhotoAndPin(dataController: self.dataController, pin:  newPin , data: imageData, urlString: currentURL.absoluteString)
                    }).resume()
                })
             self.currentSearchTask = nil   //Triggered when completely download all photos
            }
            self.currentSearchTask = nil   //Triggers when photoCount = 0  and even when there's photos because this value starts @ zero
            return
        }
        currentSearchTask = nil //Triggers when photoCount = 0  and even when there's photos because this value starts @ zero
    }
    
    
    
    func handleSearchNearbyPhotoData(urls: [URL], error: Error?){
        
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
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
    func connectPhotoAndPin(dataController: DataController, pin: Pin, data: Data, urlString: String){
        let tempPhoto = Photo(context: dataController.viewContext)
        tempPhoto.imageData = data
        tempPhoto.urlString = urlString
        tempPhoto.index = Int32(999) //Random value for init
        tempPhoto.pin = pin
        let testImage = UIImage(data: tempPhoto.imageData!)
        try? dataController.viewContext.save()
    }
    

}
