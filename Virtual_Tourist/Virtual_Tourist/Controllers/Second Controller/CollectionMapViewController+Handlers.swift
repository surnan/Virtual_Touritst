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
    
    func deleteSelectedPicture(_ sender: UIButton) {
        var pagesToDelete: Int32 = 0
        deleteIndexSet.forEach { (deleteIndex) in
            let photoToRemove = self.fetchedResultsController.object(at: deleteIndex)
            pagesToDelete = pagesToDelete + 1
            dataController.viewContext.delete(photoToRemove)
        }
        deleteIndexSet.removeAll()
        pin.photoCount = pin.photoCount - pagesToDelete
        try? dataController.viewContext.save()
        sender.isSelected = !sender.isSelected
    }
    
    func downloadNewCollectionPhotos() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetch.predicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try dataController.viewContext.execute(request)
            pin.pageNumber = pin.pageNumber + 1
            pin.photoCount = 0
            try? dataController.viewContext.save()
            try fetchedResultsController.performFetch()
            myCollectionView.reloadData()
            downloadNearbyPhotosToPin(dataController: dataController, currentPin: pin, fetchCount: fetchCount)
        } catch {
            print("unable to delete \(error)")
        }
    }
    
    @objc func handleNewLocationButton(_ sender: UIButton){
        if sender.isSelected {
            print("DELETE")
            deleteSelectedPicture(sender)
        } else {
            print("-- GET NEW PICTURES --")
            
            let block1 = BlockOperation {
                DispatchQueue.main.async {
                    self.newLocationButton.isEnabled = false
                    self.newLocationButton.backgroundColor = UIColor.yellow
                }
                self.downloadNewCollectionPhotos()
            }
            
            let block2 = BlockOperation {
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }
            
            
            let block3 = BlockOperation {
                DispatchQueue.main.async {
                    self.newLocationButton.isEnabled = false
                    self.newLocationButton.backgroundColor = UIColor.orange
                }
            }
            
            
            block2.addDependency(block1)
            block3.addDependency(block2)
            
            operationQueue.addOperations([block1, block2, block3], waitUntilFinished: false)
            
        }
    }
    
    
    
//    //let operationQueue = OperationQueue()
//    @objc func handleNewLocationButton(_ sender: UIButton){
//        if sender.isSelected {
//            print("DELETE")
//            deleteSelectedPicture(sender)
//        } else {
//
//            let block1 = BlockOperation {
//                DispatchQueue.main.async {
//                    self.newLocationButton.backgroundColor = UIColor.yellow
//                    self.newLocationButton.isEnabled = false
//                    print("---- BLOCK ONE ------")
//                }
//            }
//
//            let block2 = BlockOperation {
//                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
//                fetch.predicate = NSPredicate(format: "pin = %@", argumentArray: [self.pin])
//                let request = NSBatchDeleteRequest(fetchRequest: fetch)
//                do {
//                    _ = try self.dataController.backGroundContext.execute(request)
//                    self.pin.pageNumber = self.pin.pageNumber + 1
//                    self.pin.photoCount = 0
//                    try? self.dataController.backGroundContext.save()
//                    //                    try self.fetchedResultsController.performFetch()
//                    print("---- BLOCK TWO ------")
//                } catch {
//                    print("Unable to delete original pictures")
//                }
//            }
//            let block3 = BlockOperation {
//                downloadNearbyPhotosToPin(dataController: self.dataController, currentPin: self.pin, fetchCount: fetchCount)
//                print("---- BLOCK THREE ------")
//            }
//            let block4 = BlockOperation {
//                DispatchQueue.main.async {
//                    try? self.fetchedResultsController.performFetch()
//                    self.myCollectionView.reloadData()
//                    self.newLocationButton.backgroundColor = UIColor.orange
//                    self.newLocationButton.isEnabled = true
//                }
//                print("---- BLOCK FOUR ------")
//            }
//            block2.addDependency(block1)
//            block3.addDependency(block2)
//            block4.addDependency(block3)
//            operationQueue.addOperations([block4, block3, block2, block1], waitUntilFinished: false)
//        }
//    }
    
    
    @objc func handleReCenter(){
        myMapView.centerCoordinate = firstAnnotation.coordinate
    }
    
}


