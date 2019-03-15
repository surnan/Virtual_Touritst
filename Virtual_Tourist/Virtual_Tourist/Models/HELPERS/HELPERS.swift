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
                connectPhotoAndPin(dataController: dataController, pin:  currentPin , data: imageData, urlString: currentURL.absoluteString)
            }).resume()
        })
    }
}



func connectPhotoAndPin(dataController: DataController, pin: Pin, data: Data, urlString: String){
    let tempPhoto = Photo(context: dataController.viewContext)
    tempPhoto.imageData = data
    tempPhoto.urlString = urlString
    tempPhoto.index = Int32(999) //Random value for init
    tempPhoto.pin = pin
    let testImage = UIImage(data: tempPhoto.imageData!)
    try? dataController.viewContext.save()
}


