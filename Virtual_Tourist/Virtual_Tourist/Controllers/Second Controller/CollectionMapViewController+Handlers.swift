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
    
    @objc func handleNewLocationButton(_ sender: UIButton){
        if sender.isSelected {
            print("DELETE")
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
        } else {
            print("-- GET NEW PICTURES --")
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
            myCollectionView.reloadData()
        }
    }
    
    @objc func handleReCenter(){
        myMapView.centerCoordinate = firstAnnotation.coordinate
    }
    
}
