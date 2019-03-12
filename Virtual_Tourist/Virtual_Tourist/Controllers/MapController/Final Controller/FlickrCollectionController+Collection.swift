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

extension FinalCollectionView {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let count = fetchedResultsController.fetchedObjects?.count else {return UICollectionViewCell()}
        
        if indexPath.row < count {
//            let myPhoto = fetchedResultsController.object(at: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCar, for: indexPath) as! FirstCollectionCellCar
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idStreet, for: indexPath) as! FirstCollectionCellStreet
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = Int(pin.photoCount)
        
//        if count == 0 {
//            self.collectionView.setEmptyMessage("NOTHING TO SHOW")
//        } else {
//            self.collectionView.restore()
//        }
        return count
        //        return  min(count, (fetchedResultsController.fetchedObjects?.count)!) //<--- if you drop pin  and app crashes prior to downloading photos, you crash without this line.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
    }
}

