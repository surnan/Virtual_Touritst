//
//  ViewController.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    var mapView = MKMapView()
    var annotations = [MKPointAnnotation]()
    
    lazy var myLongPressGesture: UILongPressGestureRecognizer = {
        var longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        //        longGesture.allowableMovement = 0
        longGesture.addTarget(self, action: #selector(handleLongPress(sender:)))
        return longGesture
    }()
    
    func setupNavigationBar(){
        let editBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEditBarButton))
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    
    @objc func handleEditBarButton(){
        navigationController?.pushViewController(ShowingPicsController(), animated: true)
    }
    
    func setupUI(){
        setupNavigationBar()
        [mapView].forEach{view.addSubview($0)}
        mapView.fillSuperview()
    }
    
    func setupGestures(){
        mapView.addGestureRecognizer(myLongPressGesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        mapView.delegate = self
        setupUI()
        setupGestures()
    }
}






