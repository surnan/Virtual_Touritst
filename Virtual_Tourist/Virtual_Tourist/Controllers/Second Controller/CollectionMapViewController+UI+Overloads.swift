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
        view.backgroundColor = UIColor.purple
        setupNavigationMenu()
        setupMapView()
        [myMapView, myCollectionView, newLocationButton, screenBottomFiller].forEach{ view.addSubview($0) }
        setupUI()
        setupFetchedResultsController()
    }
    
    
    func setupViewForFade(){
        view.addSubview(refreshingScreen)
        refreshingScreen.addSubview(myActivityIndicatorView)
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
    }
}
