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


protocol FlickrCollectionControllerDelegate {
    func refresh()
}


class FlickrCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, FlickrCollectionControllerDelegate {
    
    func refresh() {
        do {
            print("refresh ---- * INSIDE FLICKR-CONTROLLER * ")
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    @objc func handleReload(){
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
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
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "refresh", style: .done, target: self, action: #selector(handleReload)),
            UIBarButtonItem(title: "Update_Page", style: .done, target: self, action: #selector(handleUpdatePage)),
        ]
    }
    
    
    @objc func handleUpdatePage(){
        
        print(pin.pageNumber)
        pin.pageNumber = pin.pageNumber + 1
        try? dataController.viewContext.save()
        print(pin.pageNumber)
    }
    
    
    
    @objc func handleLeftBarButton(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        collectionView.register(CollectionCell3.self, forCellWithReuseIdentifier: reuseID)
        view.backgroundColor = UIColor.red
        showNavigationController()
        setupFetchedResultsController()
        
        print("TEST")
        
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



