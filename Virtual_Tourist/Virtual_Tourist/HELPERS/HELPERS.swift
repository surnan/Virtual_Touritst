//
//  HELPERS.swift
//  Virtual_Tourist
//
//  Created by admin on 3/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData



func connectPhotoAndPin(dataController: DataController, pin: Pin, data: Data, urlString: String){
    let tempPhoto = Photo(context: dataController.viewContext)
    tempPhoto.imageData = data
    tempPhoto.urlString = urlString
    tempPhoto.index = Int32(999) //Random value for init
    tempPhoto.pin = pin
    let testImage = UIImage(data: tempPhoto.imageData!)
    try? dataController.viewContext.save()
}
