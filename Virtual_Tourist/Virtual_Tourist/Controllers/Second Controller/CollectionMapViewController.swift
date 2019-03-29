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
        photosIndicesDict.removeAll()
        if let items = self.pin.photos {
            items.map{$0 as! Photo}.forEach{
                let indexPathToInsert = IndexPath(item: Int($0.index), section: 0)
                let photoObjectID = $0.objectID
                photosIndicesDict[indexPathToInsert] = photoObjectID
                try? fetchedResultsController.performFetch()
                myCollectionView.reloadData()
            }
        }
    }
    
    
    //MARK:-  Var
    var pin: Pin!   //injected from MapController
    var dataController: DataController! //injected from MapController

    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    let reuseIdLoadingCell = "reuseIdLoadingCell"
    let reuseIDCellLoaded = "reuseIDCellLoaded"
    let reuseIDCellIsSelected = "reuseIDCellIsSelected"
    let mapRegionDistanceValue: CLLocationDistance = 1500
    
    var deleteIndexSet = Set<IndexPath>() {
        didSet {
            newLocationButton.isSelected = !deleteIndexSet.isEmpty
        }
    }
    
    var photosIndicesDict = [IndexPath: NSManagedObjectID]()
    
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
        collectionView.backgroundColor = UIColor.clear
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


    lazy var collectionViewEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.numberOfLines = 0;
        label.textAlignment = .center;
        label.text = "No Photos on this Pin"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton()
        let attribString = NSAttributedString(string: "Retry Query", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)
            ])
        button.setAttributedTitle(attribString, for: .normal)
        button.addTarget(self, action: #selector(handleRefreshButton), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    var emptyCollectionStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    lazy var firstAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        return annotation
    }()
    
    
    lazy var activityView: UIActivityIndicatorView = {
       let activityVC = UIActivityIndicatorView()
        activityVC.hidesWhenStopped = true
        activityVC.style = .gray
        activityVC.translatesAutoresizingMaskIntoConstraints = false
        return activityVC
    }()
    
    deinit {
        fetchedResultsController = nil
    }
}
