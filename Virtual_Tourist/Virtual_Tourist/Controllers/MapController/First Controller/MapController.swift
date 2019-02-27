//
//  ViewController.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {
    
    var mapView = MKMapView()
    
    
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
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //            pinView?.clusteringIdentifier = "identifier"
            pinView?.displayPriority = .defaultHigh
            pinView!.canShowCallout = true
            pinView!.tintColor = .blue
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}






