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
