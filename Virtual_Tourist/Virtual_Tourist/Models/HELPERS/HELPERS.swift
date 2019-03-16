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


var globalTask: URLSessionTask?

func downloadNearbyPhotosToPin(dataController: DataController, currentPin: Pin, fetchCount: Int) {
    //TODO: User should get an indicator that cell count = zero because download incoming?  Loading cells don't show here
    
    if globalTask != nil {
        print("CANCELLED DOWNOAD")
        return
    }
    
    let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
    let currentPinID = currentPin.objectID
    
    //    backgroundContext.perform { //+2
    //        let backgroundPin = backgroundContext.object(with: currentPinID) as! Pin
    
    
    globalTask = FlickrClient.searchNearbyPhotoData(currentPin: currentPin, fetchCount: fetchCount) { (urls, error) in //+1
        if let error = error {
            print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
            return
        }
        backgroundContext.perform { //+2
            let backgroundPin = backgroundContext.object(with: currentPinID) as! Pin
            backgroundPin.photoCount = Int32(urls.count)
            try? backgroundContext.save()
        }   //-2
        urls.forEach({ (currentURL) in
            print("URL inside loop --> \(currentURL)")
            URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                print("currentURL = \(currentURL)")
                guard let imageData = imageData else {return}
                connectPhotoAndPin(dataController: dataController, currentPin:  currentPin , data: imageData, urlString: currentURL.absoluteString)
            }).resume()
        })
     globalTask = nil
    }   //-1
    //    }   //-2
}



func connectPhotoAndPin(dataController: DataController, currentPin: Pin, data: Data, urlString: String){
    /*
    let backgroundContext: NSManagedObjectContext! = dataController.backGroundContext
    let currentPinID = currentPin.objectID
    backgroundContext.perform {
        let backgroundPin = backgroundContext.object(with: currentPinID) as! Pin
        let tempPhoto = Photo(context: backgroundContext)
        tempPhoto.imageData = data
        tempPhoto.urlString = urlString
        tempPhoto.index = Int32(999) //Random value for init
        tempPhoto.pin = backgroundPin
        //        let testImage = UIImage(data: tempPhoto.imageData!)
        try? backgroundContext.save()
    }
    */
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //    let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
    //    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    //    privateMOC.parent = moc
    //
    //    privateMOC.perform({
    //        do {
    //            try privateMOC.save()
    //        } catch {
    //            fatalError("Failure to save context: \(error)")
    //        }
    //    })
    //
    

    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    privateMOC.perform {
        do {
            try privateMOC.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
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

