//
//  AnotherVC.swift
//  Loading Screen Test
//
//  Created by admin on 3/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData


protocol FinalCollectionViewDelegate {
    func refresh()
}

class FinalCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate, FinalCollectionViewDelegate {
    var pin: Pin!
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var myFetchController: NSFetchedResultsController<Photo>!
    
    let reuseIdLoadingCell = "reuseIdLoadingCell"
    let reuseIDCellLoaded = "reuseIDCellLoaded"
    let reuseIDCellIsSelected = "reuseIDCellIsSelected"
    
    lazy var photoMaxCount = pin.photoCount
    
    var deleteIndexSet = Set<IndexPath>() {
        didSet {
            newLocationButton.isSelected = !deleteIndexSet.isEmpty
        }
    }
    
    //MARK:-Protocol
    func refresh() {
        do {
            try fetchedResultsController.performFetch()
            myCollectionView.reloadData()
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
        tempPhoto.index = Int32(999) //Random value for init
        tempPhoto.pin = pin
        let testImage = UIImage(data: tempPhoto.imageData!)
        try? dataController.viewContext.save()
    }
    

    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 100, height: 100)
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    //    }

    lazy var customizedLayout: UICollectionViewFlowLayout = {
        let columnWidth: CGFloat = 10; let rowHeight: CGFloat = 10
        let screenWidth = view.bounds.width
        
        let cellWidth = (screenWidth - 60) / 3
        let cellWidth2 = (screenWidth - columnWidth * 5) / 3
        
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: columnWidth, left: columnWidth, bottom: columnWidth, right: columnWidth)
        layout.itemSize = .init(width: cellWidth2, height:   cellWidth2)
        
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = rowHeight
        layout.minimumInteritemSpacing = columnWidth
        return layout
    }()
    
    lazy var myCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: customizedLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FinalCollectionLoadingCell.self, forCellWithReuseIdentifier: reuseIdLoadingCell)
        collectionView.register(FinalCollectionImageCell.self, forCellWithReuseIdentifier: reuseIDCellLoaded)
        collectionView.register(FinalCollectionSelectedImageCell.self, forCellWithReuseIdentifier: reuseIDCellIsSelected)
    
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var newLocationButton: UIButton = {
       let button = UIButton()
        button.setTitle("New Collection", for: .normal)
        button.backgroundColor = UIColor.blue
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.setTitle("Remove Selected Pictures", for: .selected)
        button.setTitleColor(UIColor.red, for: .selected)
        
        button.addTarget(self, action: #selector(handleNewLocationButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleNewLocationButton(_ sender: UIButton){
        if sender.isSelected {
            print("DELETE")
            
            var pagesToDelete: Int32 = 0
            deleteIndexSet.forEach { (deleteIndex) in
                let photoToRemove = self.fetchedResultsController.object(at: deleteIndex)
                pagesToDelete = pagesToDelete + 1
                dataController.viewContext.delete(photoToRemove)
            }
            deleteIndexSet.removeAll()
            pin.photoCount = pin.photoCount - pagesToDelete
            try? dataController.viewContext.save()
            sender.isSelected = !sender.isSelected
        } else {
            print("-- GET NEW PICTURES --")
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            fetch.predicate = NSPredicate(format: "pin = %@", argumentArray: [pin])
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                _ = try dataController.viewContext.execute(request)
                
                pin.pageNumber = pin.pageNumber + 1
                pin.photoCount = 0
                try? dataController.viewContext.save()
                
                try fetchedResultsController.performFetch()
                myCollectionView.reloadData()
                
                //TODO: User should get an indicator that cell count = zero because download incoming?  Loading cells don't show here
                
                FlickrClient.searchNearbyPhotoData(currentPin: pin, fetchCount: fetchCount) { (urls, error) in
                    if let error = error {
                        print("func mapView(_ mapView: MKMapView, didSelect... \n\(error)")
                        return
                    }
                    
                    self.pin.photoCount = Int32(urls.count)
                    try? self.dataController.viewContext.save()
                    
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
            myCollectionView.reloadData()
        }
    }
    
    var myMapView: MKMapView = {
       let map = MKMapView()
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.mapType = .standard
        map.showsCompass = true //not working on simulator
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    
    //MARK:- overloads  ui
    override func viewDidLoad() {
        view.backgroundColor = UIColor.purple
        setupNavigationMenu()
        setupMapView()
        [myMapView, myCollectionView, newLocationButton, screenBottomFiller].forEach{ view.addSubview($0) }
        setupUI()
        setupFetchedResultsController()
    }
    
    deinit {
        fetchedResultsController = nil
    }
    

    func setupNavigationMenu(){
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Re-Center", style: .done, target: self, action: #selector(handleReCenter))]
    }

    lazy var firstAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        return annotation
    }()
    
    @objc func handleReCenter(){
        myMapView.centerCoordinate = firstAnnotation.coordinate
    }
    
    func setupMapView() {
        myMapView.addAnnotation(firstAnnotation)
        myMapView.centerCoordinate = firstAnnotation.coordinate
        //Setting up Zoom
        let noLocation = firstAnnotation.coordinate
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        myMapView.setRegion(viewRegion, animated: false)
    }
    
    var screenBottomFiller: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    func setupUI(){
        let safe = view.safeAreaLayoutGuide
        myMapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        myMapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        myCollectionView.anchor(top: myMapView.bottomAnchor, leading: myMapView.leadingAnchor, trailing: myMapView.trailingAnchor, bottom:
            newLocationButton.topAnchor)
        newLocationButton.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: safe.bottomAnchor)
        screenBottomFiller.anchor(top: newLocationButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
    }
}
