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

//var imageArray = [UIImage]()

class FlickrCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    let reuseID = "alksdjfhaskdjhf"
    
    var pin: Pin!
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var photoID_Secret_Dict = [[String: String]]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setupFetchedResultsController()
        print("test")
    }
    
    
    func showNavigationController(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<custom back", style: .done, target: self, action: #selector(handleLeftBarButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "refresh", style: .done, target: self, action: #selector(reload))
    }
    
    @objc func handleLeftBarButton(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
//        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: reuseID)
        collectionView.register(CollectionCell3.self, forCellWithReuseIdentifier: reuseID)
        view.backgroundColor = UIColor.red
        showNavigationController()
        setupFetchedResultsController()
        
        print("TEST")
        
    }
    
    @objc func reload(){
        collectionView.reloadData()
    }
    
    
    deinit {
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "urlString", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
}



