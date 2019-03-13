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
            downloadNearbyPhotosToPin(dataController: dataController, currentPin: newPin, fetchCount: fetchCount)
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
    
    func downloadNearbyPhotosToPin(dataController: DataController, currentPin: Pin, fetchCount: Int) {
        //TODO: User should get an indicator that cell count = zero because download incoming?  Loading cells don't show here
        FlickrClient.searchNearbyPhotoData(currentPin: currentPin, fetchCount: fetchCount) { (urls, error) in
            if let error = error {
                print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
                return
            }
            currentPin.photoCount = Int32(urls.count)
            try? dataController.viewContext.save()
            urls.forEach({ (currentURL) in
                print("URL inside loop --> \(currentURL)")
                URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                    print("currentURL = \(currentURL)")
                    guard let imageData = imageData else {return}
                    self.connectPhotoAndPin(dataController: dataController, pin:  currentPin , data: imageData, urlString: currentURL.absoluteString)
                }).resume()
            })
        }
    }
}
