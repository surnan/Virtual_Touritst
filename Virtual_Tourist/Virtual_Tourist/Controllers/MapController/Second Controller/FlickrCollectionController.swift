////
////  ShowingPicsController.swift
////  Virtual_Tourist
////
////  Created by admin on 2/26/19.
////  Copyright © 2019 admin. All rights reserved.
////
//
import UIKit
import MapKit
import CoreData

var imageArray = [UIImage]()

class FlickrCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let reuseID = "alksdjfhaskdjhf"
    
    var Pin: Pin!
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("test")
    }
    
    
    
   
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func showNavigationController(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(handleLeftBarButton))
    }
    
    @objc func handleLeftBarButton(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        collectionView.register(CollectionCell2.self, forCellWithReuseIdentifier: reuseID)
        view.backgroundColor = UIColor.red
    }
}
