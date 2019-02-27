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
        let editDoneButton: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.setTitle("Edit", for: .normal)
            button.setTitle("Done", for: .selected)
            button.addTarget(self, action: #selector(handleRightBarButton), for: .touchUpInside)
            button.isSelected = false
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        let customBarButton = UIBarButtonItem(customView: editDoneButton)
        self.navigationItem.setRightBarButton(customBarButton, animated: true)
    }
    
    
    @objc func handleRightBarButton(sender: UIButton){
        sender.isSelected = !sender.isSelected
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






