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
            
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
            
            
            
            downloadNearbyPhotosToPin(dataController: dataController, currentPin: pin, fetchCount: fetchCount)
        } catch {
            print("unable to delete \(error)")
        }
    }
    
    @objc func handleNewLocationButton(_ sender: UIButton){
        
        
        let queue = DispatchQueue(label: "com.company.app.queue", attributes: .concurrent)
        let dispatchWorkItem = DispatchWorkItem(qos: .default, flags: .barrier) {
            print("#3 finished")
            DispatchQueue.main.async {
                sender.backgroundColor = UIColor.purple
            }
        }

        
        
        if sender.isSelected {
            print("DELETE")
            deleteSelectedPicture(sender)
        } else {
            
        
            
            
            
            queue.async {
                DispatchQueue.main.async {
                    sender.backgroundColor = UIColor.yellow
                }
                
                print("-- GET NEW PICTURES --")
                self.downloadNewCollectionPhotos()
                self.myCollectionView.reloadData()
            }

        
        queue.async(execute: dispatchWorkItem)
        
        
        
        
        
        }
    }
    
    @objc func handleReCenter(){
        myMapView.centerCoordinate = firstAnnotation.coordinate
    }
    
}
