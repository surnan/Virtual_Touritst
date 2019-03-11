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

extension FlickrCollectionController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let count = fetchedResultsController.fetchedObjects?.count else {return UICollectionViewCell()}
        
        if indexPath.row < count {
            let myPhoto = fetchedResultsController.object(at: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID3, for: indexPath) as! CollectionCell3
            cell.myPhoto = myPhoto
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID2, for: indexPath) as! CollectionCell2
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = Int(pin.photoCount)
        
        if count == 0 {
            self.collectionView.setEmptyMessage("NOTHING TO SHOW")
        } else {
            self.collectionView.restore()
        }
        return count
        //        return  min(count, (fetchedResultsController.fetchedObjects?.count)!) //<--- if you drop pin  and app crashes prior to downloading photos, you crash without this line.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
    }
}

extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
