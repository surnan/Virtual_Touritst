//
//  HELPERS.swift
//  Virtual_Tourist
//
//  Created by admin on 3/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData

//downloadNearbyPhotosToPin

func downloadNearbyPhotosToPin(dataController: DataController, currentPin: Pin, fetchCount: Int) {
    //TODO: User should get an indicator that cell count = zero because download incoming?  Loading cells don't show here
    
    //long-term background context
    let backgroundContext = dataController.backGroundContext! //ALWAYS defined from DataController().init, so it's safe
    
    
    let currentPinID = currentPin.objectID
    
    backgroundContext.perform {
        let backgroundPin = backgroundContext.object(with: currentPinID) as! Pin  //Can't use currentPin from MainQueue directly
        FlickrClient.searchNearbyPhotoData(currentPin: backgroundPin, fetchCount: fetchCount) { (urls, error) in
            if let error = error {
                print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
                return
            }
            backgroundPin.photoCount = Int32(urls.count)
            try? backgroundContext.save()
            urls.forEach({ (currentURL) in
                print("URL inside loop --> \(currentURL)")
                URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                    print("currentURL = \(currentURL)")
                    guard let imageData = imageData else {return}
                    connectPhotoAndPin(dataController: dataController, currentPin:  backgroundPin , data: imageData, urlString: currentURL.absoluteString)
                }).resume()
            })
        }
    }
}


func connectPhotoAndPin(dataController: DataController, currentPin: Pin, data: Data, urlString: String){
    let currentPinID = currentPin.objectID
    //generates multiple background context and allows O/S to consid er parallel for performance
    dataController.persistentContainer.performBackgroundTask { (context) in
        let backgroundPin = context.object(with: currentPinID) as! Pin
        let tempPhoto = Photo(context: context)
        tempPhoto.imageData = data
        tempPhoto.urlString = urlString
        tempPhoto.index = Int32(999) //Random value for init
        tempPhoto.pin = backgroundPin
        //        let testImage = UIImage(data: tempPhoto.imageData!)
        try? context.save()
    }
}


//NSNotification.Name?
extension MapController {
    func addSaveNotifcationObserver(){
        removeSaveNotificationObserver()
        saveObserverToken = NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: dataController.viewContext, queue: nil, using: handleSaveNotification(notification:))
    }
    
    func removeSaveNotificationObserver(){
        if let token = saveObserverToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func handleSaveNotification(notification: Notification){
        DispatchQueue.main.async {
            print("Core Data Updated and UI upgraded through NSFetchResults --> 'didChange anObject'  ")
        }
    }
}

