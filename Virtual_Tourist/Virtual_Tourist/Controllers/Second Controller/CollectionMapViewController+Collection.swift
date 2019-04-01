//
//  FlickrCollectionController+Collection.swift
//  Virtual_Tourist
//
//  Created by admin on 3/6/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData


let idPlain = "asdf"
let idCar = "asdfCARCAR"
let idStreet = "asdfasdfSTREETSTREET"

extension CollectionMapViewController {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if pin.allPhotosDownloaded {
            if deleteIndexSet.contains(indexPath) {
                let myPhoto = fetchedResultsController.object(at: indexPath)
                let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIDCellIsSelected, for: indexPath) as! FinalCollectionSelectedImageCell
                cell.myPhoto = myPhoto
                return cell
            } else {
                let myPhoto = fetchedResultsController.object(at: indexPath)
                let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIDCellLoaded, for: indexPath) as! FinalCollectionImageCell
                cell.myPhoto = myPhoto
                return cell
            }
        }

        if let photoID = photosIndicesDict[indexPath] {
            let currentPhoto = self.dataController.viewContext.object(with: photoID) as! Photo
            let cell2 = self.myCollectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIDCellLoaded, for: indexPath) as! FinalCollectionImageCell
            cell2.myPhoto = currentPhoto
//            print("indexPath = \(indexPath) .... photoID found")
            return cell2
        }
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdLoadingCell, for: indexPath) as! FinalCollectionLoadingCell
//        print("indexPath = \(indexPath)")
        return cell
    }

 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(pin.urlCount)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Cell = \(indexPath)")
        if deleteIndexSet.contains(indexPath) {
            deleteIndexSet.remove(indexPath)
        } else {
            deleteIndexSet.insert(indexPath)
        }
        myCollectionView.reloadItems(at: [indexPath])
    }
}


