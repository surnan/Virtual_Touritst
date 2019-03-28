//
//  CollectionMapViewController+UI+Overloads.swift
//  Virtual_Tourist
//
//  Created by admin on 3/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData


extension CollectionMapViewController {
    //MARK:- overloads  ui
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        setupNavigationMenu()
        setupMapView()
        [collectionViewEmptyLabel, refreshButton].forEach{emptyCollectionStack.addArrangedSubview($0)}
        [emptyCollectionStack, myMapView, myCollectionView, newLocationButton, screenBottomFiller, activityView].forEach{view.addSubview($0) }
        
        setupUI()
        setupFetchedResultsController()
        refresh()
        
        if pin.urlCount == 0 {
            emptyCollectionStack.isHidden = false
        }
        
        //TODO: Verify that pin.PhotoCount correctly matches how many photos are attached.  When this value is out of sync, app crashes
        
        
    }
    
    
    func setupNavigationMenu(){
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Re-Center", style: .done, target: self, action: #selector(handleReCenter))]
    }
    
    
    func setupUI(){
        let safe = view.safeAreaLayoutGuide
        myMapView.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, trailing: safe.trailingAnchor)
        myMapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        myCollectionView.anchor(top: myMapView.bottomAnchor, leading: myMapView.leadingAnchor, trailing: myMapView.trailingAnchor, bottom:
            newLocationButton.topAnchor)
        newLocationButton.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: safe.bottomAnchor)
        screenBottomFiller.anchor(top: newLocationButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        emptyCollectionStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyCollectionStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
