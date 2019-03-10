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
    let reuseID = "alksdjfhaskdjhf"
    var pin: Pin!
    var dataController: DataController!
    var photoID_Secret_Dict = [[String: String]]()
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var myFetchController: NSFetchedResultsController<Photo>!
    
    
    //MARK:-Protocol
    func refresh() {
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    //MARK:- FetchResults + CoreData
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
    
    func connectPhotoAndPin(dataController: DataController, pin: Pin, data: Data, urlString: String){
        let tempPhoto = Photo(context: dataController.viewContext)
        tempPhoto.imageData = data
        tempPhoto.urlString = urlString
        tempPhoto.index = Int32(718212)
        tempPhoto.pin = pin
        let testImage = UIImage(data: tempPhoto.imageData!)
        try? dataController.viewContext.save()
    }
    
    @objc func handleLeftBarButton(){
        navigationController?.popViewController(animated: true)
    }

    
    //UI and Swift Overloads
    override func viewDidLoad() {
        collectionView.register(CollectionCell3.self, forCellWithReuseIdentifier: reuseID)
        collectionView.register(CollectionCell2.self, forCellWithReuseIdentifier: reuseID)
        view.backgroundColor = UIColor.red
        showNavigationController()
        setupFetchedResultsController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("test")
    }
    
    deinit {
        fetchedResultsController = nil
    }
    
    
    //MARK:- Navigation Bar and it's Handlers
    func showNavigationController(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<custom back", style: .done, target: self, action: #selector(handleLeftBarButton))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "reload", style: .done, target: self, action: #selector(handleReload)),
            UIBarButtonItem(title: "Update_Page", style: .done, target: self, action: #selector(handleUpdatePage)),
        ]
    }
    
    @objc func handleReload(){
        do {
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    @objc func handleUpdatePage(){
        pin.pageNumber = pin.pageNumber + 1
        try? dataController.viewContext.save()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetch.predicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try dataController.viewContext.execute(request)
            try fetchedResultsController.performFetch()
            collectionView.reloadData()
            FlickrClient.searchNearbyPhotoData(currentPin: pin, fetchCount: fetchCount) { (urls, error) in
                if let error = error {
                    print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
                    return
                }
                urls.forEach({ (currentURL) in
                    print("URL inside loop --> \(currentURL)")
                    URLSession.shared.dataTask(with: currentURL, completionHandler: { (imageData, response, error) in
                        print("currentURL = \(currentURL)")
                        guard let imageData = imageData else {return}
                        self.connectPhotoAndPin(dataController: self.dataController, pin:  self.pin , data: imageData, urlString: "456")
                    }).resume()
                })
            }
        } catch {
            print("unable to delete \(error)")
        }
        self.collectionView.reloadData()
    }
}
