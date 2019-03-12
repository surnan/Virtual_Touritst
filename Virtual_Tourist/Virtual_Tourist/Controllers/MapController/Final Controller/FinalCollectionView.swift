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
    var photoID_Secret_Dict = [[String: String]]()
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var myFetchController: NSFetchedResultsController<Photo>!
    
    var deleteIndexSet = Set<IndexPath>() {
        didSet {
            myButton.isSelected = !deleteIndexSet.isEmpty
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
        tempPhoto.index = Int32(718212)
        tempPhoto.pin = pin
        let testImage = UIImage(data: tempPhoto.imageData!)
        try? dataController.viewContext.save()
    }
    
//////////
    
    let idPlain = "asdf"
    let idCar = "asdfCARCAR"
    let idStreet = "asdfasdfSTREETSTREET"

    let layout: UICollectionViewFlowLayout = {
        let temp = UICollectionViewFlowLayout()
        temp.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        temp.itemSize = .init(width: 75, height:   75)
        temp.scrollDirection = .vertical
        temp.minimumLineSpacing = 10
        temp.minimumInteritemSpacing = 10
        return temp
    }()
    
    lazy var myCollectionView: UICollectionView = {
        var myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: idPlain)
        myCollectionView.register(FirstCollectionCellCar.self, forCellWithReuseIdentifier: idCar)
        myCollectionView.register(FirstCollectionCellStreet.self, forCellWithReuseIdentifier: idStreet)
        
        
        myCollectionView.showsVerticalScrollIndicator = false
        myCollectionView.backgroundColor = UIColor.black
        myCollectionView.allowsMultipleSelection = true
        return myCollectionView
    }()
    
    lazy var myButton: UIButton = {
       let button = UIButton()
        button.setTitle("New Collection", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.setTitle("Remove Selected Pictures", for: .selected)
        button.setTitleColor(UIColor.red, for: .selected)
        
        button.addTarget(self, action: #selector(handleMyButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    var myMapView: MKMapView = {
       let map = MKMapView()
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.mapType = .standard
        map.showsCompass = true //not working on simulator
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    
    @objc func handleMyButton(_ sender: UIButton){
        print("Hello World")
        sender.isSelected = !sender.isSelected
    }
    
    
    //MARK:- overloads  ui
    override func viewDidLoad() {
        view.backgroundColor = UIColor.blue
        setupNavigationMenu()
        setupMapView()
        [myMapView, myCollectionView, myButton].forEach{ view.addSubview($0) }
        setupCollectionView()
        myCollectionView.register(FirstCollectionCellStreet.self, forCellWithReuseIdentifier: idStreet)
        myCollectionView.register(FirstCollectionCellCar.self, forCellWithReuseIdentifier: idCar)
        setupFetchedResultsController()
    }
    
    deinit {
        fetchedResultsController = nil
    }
    
    
    
    
    func setupNavigationMenu(){
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Re-Center", style: .done, target: self, action: #selector(handleReCenter)), UIBarButtonItem(title: "Update_Page", style: .done, target: self, action: #selector(handleUpdatePage))]
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
            myCollectionView.reloadData()
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
    
    func setupCollectionView(){
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            myMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            myMapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            myButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            myButton.widthAnchor.constraint(equalTo: view.widthAnchor),
            myButton.heightAnchor.constraint(equalToConstant: 30),
            
            myCollectionView.topAnchor.constraint(equalTo: myMapView.bottomAnchor, constant: 10),
            myCollectionView.bottomAnchor.constraint(equalTo: myButton.topAnchor, constant: -10),
            myCollectionView.leadingAnchor.constraint(equalTo: myMapView.leadingAnchor),
            myCollectionView.trailingAnchor.constraint(equalTo: myMapView.trailingAnchor),
            ])
    }
}
