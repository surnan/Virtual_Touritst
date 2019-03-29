//
//  CollectionMapViewController+Handlers.swift
//  Virtual_Tourist
//
//  Created by admin on 3/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData

extension CollectionMapViewController {
    
    func removeSelectedPicture(_ sender: UIButton) {
        var pagesToDelete: Int32 = 0
        deleteIndexSet.forEach { (deleteIndex) in
            let photoToRemove = self.fetchedResultsController.object(at: deleteIndex)
            pagesToDelete = pagesToDelete + 1
            dataController.viewContext.delete(photoToRemove)
        }
        deleteIndexSet.removeAll()
        pin.photoCount = pin.photoCount - pagesToDelete
        pin.urlCount = pin.urlCount - pagesToDelete
        try? dataController.viewContext.save()
//        sender.isSelected = !sender.isSelected
    }
    

    @objc func handleNewLocationButton(_ sender: UIButton){
        //TODO: Delete Pictures auto converts to "NEW COLLECTION" before hitting the if statement
        if sender.isSelected {
            print("DELETE")
            removeSelectedPicture(sender)
        } else {
            print("-- GET NEW PICTURES --")
            synchronouslyDeletePhotosAndRedownloadOnPin()
        }
    }
    
    
    @objc func handleRefreshButton(){
        print("BUTTON PRESSED")
        synchronouslyDeletePhotosAndRedownloadOnPin()
    }
    
    func synchronouslyDeletePhotosAndRedownloadOnPin() {
        let operationQueue = OperationQueue()
        
        let block1 = BlockOperation {
            DispatchQueue.main.async {
                self.activityView.startAnimating()
                self.newLocationButton.isEnabled = false
                self.newLocationButton.backgroundColor = UIColor.yellow
                self.emptyCollectionStack.isHidden = true
            }
            self.deleteCurrentPicturesOnPin()
        }
        
        let block2 = BlockOperation {
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
    
        
        let block3 = BlockOperation {
            _ = FlickrClient.getAllPhotoURLs(currentPin: self.pin, fetchCount: fetchCount, completion: self.handleGetAllPhotoURLs(pin:urls:error:))
        }
        
        block2.addDependency(block1)
        block3.addDependency(block2)
        operationQueue.addOperations([block1, block2, block3], waitUntilFinished: false)
    }

    
    
//    DispatchQueue.main.async {
//    if backgroundPin.urlCount == 0 {
//    self.activityView.stopAnimating()
//    self.emptyCollectionStack.isHidden = false
//    self.newLocationButton.isEnabled = true
//    self.newLocationButton.backgroundColor = UIColor.orange
//    }
//    }
    
    
    
    func handleGetAllPhotoURLs(pin: Pin, urls: [URL], error: Error?){
        
        if let error = error {
            print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
            return
        }
        
        let myQueue = OperationQueue()
        
        let blockOne = BlockOperation {
            print("***   BLOCK 1   ***")
            //Setting pin.urlCount
            let backgroundContext: NSManagedObjectContext! = self.dataController.backGroundContext
            backgroundContext.perform {
                let currentPinID = pin.objectID
                let backgroundPin = backgroundContext.object(with: currentPinID) as! Pin
                backgroundPin.urlCount = Int32(urls.count)
                try? backgroundContext.save()
            }
        }
        
        let blockTwo = BlockOperation {
            print("***   BLOCK 2   --- urls.count --> \(urls.count)")
            for (index, currentURL) in urls.enumerated() {
                URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in  //1
                    guard let imageData = imageData else {return}
                    connectPhotoAndPin(dataController: self.dataController, currentPin:  pin , data: imageData, urlString: currentURL.absoluteString, index: index) //2
                }).resume()
            }
        }
        
        let blockThree = BlockOperation {
            print("***   BLOCK 3   ***")
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                self.newLocationButton.isEnabled = true
                if pin.photoCount == 0 {                            //3
                    print("SHOWING")
                    self.emptyCollectionStack.isHidden = false
                } else {
                    print("HIDING")
                    self.emptyCollectionStack.isHidden = true
                }
            }
        }
        
        blockTwo.addDependency(blockOne)
        blockThree.addDependency(blockTwo)
        myQueue.addOperations([blockOne, blockTwo, blockThree], waitUntilFinished: true)
    }
    
    
    
    
//    self.newLocationButton.isEnabled = true
//    self.newLocationButton.backgroundColor = UIColor.orange
    
    
    
    func deleteCurrentPicturesOnPin() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetch.predicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try dataController.viewContext.execute(request)
            pin.pageNumber = pin.pageNumber + 1
            pin.photoCount = 0
            pin.urlCount = 0
            try? dataController.viewContext.save()
            try fetchedResultsController.performFetch()
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        } catch {
            print("unable to delete \(error)")
        }
    }
    

    @objc func handleReCenter(){
        myMapView.centerCoordinate = firstAnnotation.coordinate
    }
}

