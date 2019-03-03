//
//  ShowingPicsController.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


class ShowingPicsController: UIViewController {
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        <#code#>
//    }
    
    
    func showNavigationController(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(handleLeftBarButton))
    }
    
    
    @objc func handleLeftBarButton(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.red
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 50, height: 50)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let newController = MemeCreationController()
////        newController.currentMeme = memes[indexPath.item]
////        newController.currentIndex = indexPath.item
////        navigationController?.pushViewController(newController, animated: true)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return memes.count
//        return 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! MemeCollectionViewCell
////        tempCell.currentMeme =  memes[indexPath.item]
////        return tempCell
//
//        return UICollectionViewCell()
//
//    }
}
