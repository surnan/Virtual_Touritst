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


protocol CollectionMapViewControllerDelegate {
    func refresh()
}

class CollectionMapViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate, CollectionMapViewControllerDelegate, MKMapViewDelegate {
    
    
    //MARK:-Protocol
    func refresh() {
        do {
            try fetchedResultsController.performFetch()
            myCollectionView.reloadData()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    //MARK:-  Var
    var pin: Pin!
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var myFetchController: NSFetchedResultsController<Photo>!
    
    let reuseIdLoadingCell = "reuseIdLoadingCell"
    let reuseIDCellLoaded = "reuseIDCellLoaded"
    let reuseIDCellIsSelected = "reuseIDCellIsSelected"
    let mapRegionDistanceValue: CLLocationDistance = 1500
    
    var deleteIndexSet = Set<IndexPath>() {
        didSet {
            newLocationButton.isSelected = !deleteIndexSet.isEmpty
        }
    }
    

    
    var screenBottomFiller: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()


    //MARK:- Lazy Var
    lazy var photoMaxCount = pin.photoCount
    
    lazy var myMapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.isScrollEnabled = true
        map.isZoomEnabled = true
        map.mapType = .standard
        map.showsCompass = true //not working on simulator
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
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

    lazy var firstAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        return annotation
    }()
    
    deinit {
        fetchedResultsController = nil
    }
}
