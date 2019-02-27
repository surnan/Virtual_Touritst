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
    
    var mapView: MKMapView = {
       let view = MKMapView()
//        view.clipsToBounds = true
        return view
    }()
        
    
    var annotations = [MKPointAnnotation]()
    
    lazy var myLongPressGesture: UILongPressGestureRecognizer = {
        var longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        //        longGesture.allowableMovement = 0
        longGesture.addTarget(self, action: #selector(handleLongPress(sender:)))
        return longGesture
    }()
    
    let bottomUILabelHeight: CGFloat = 100
    var mapViewTopAnchor_safeTop: NSLayoutConstraint?
    var mapViewTopAnchor_safeTop_EXTRA: NSLayoutConstraint?
    var mapViewHeightAnchor: NSLayoutConstraint?
    var mapViewHeightAnchor_EXTRA: NSLayoutConstraint?
    
    var mapViewBottomAnchor_viewBottom: NSLayoutConstraint?
    var mapViewBottomAnchor_viewBottom_EXTRA: NSLayoutConstraint?
    
    
    lazy var bottomUILabel: UILabel = {
       var label = UILabel()
        label.backgroundColor = UIColor.red
        let attributes: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25),
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        label.attributedText = NSAttributedString(string: "Tap Pins to Delete", attributes: attributes)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: bottomUILabelHeight).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    func setupNavigationBar(){
        let editDoneButton: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setTitleColor(UIColor.blue, for: .selected)
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
        toggleBottomUILabel(show: sender.isSelected)
    }

    func setupUI(){
        setupNavigationBar()
        [mapView, bottomUILabel].forEach{view.addSubview($0)}
        mapView.anchor(top: nil, leading: bottomUILabel.leadingAnchor, trailing: bottomUILabel.trailingAnchor, bottom: nil)
        bottomUILabel.anchor(top: mapView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil)

        
         mapViewTopAnchor_safeTop =  mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
         mapViewBottomAnchor_viewBottom =  mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        mapViewTopAnchor_safeTop_EXTRA = mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -bottomUILabelHeight)
        mapViewBottomAnchor_viewBottom_EXTRA = mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomUILabelHeight)
        
        mapViewTopAnchor_safeTop?.isActive = true
        mapViewTopAnchor_safeTop_EXTRA?.isActive = false
        
        mapViewBottomAnchor_viewBottom?.isActive = true
        mapViewBottomAnchor_viewBottom_EXTRA?.isActive = false
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
    
    func toggleBottomUILabel(show: Bool){
        
        mapViewTopAnchor_safeTop?.isActive = false
        mapViewTopAnchor_safeTop_EXTRA?.isActive = false
        mapViewBottomAnchor_viewBottom?.isActive = false
        mapViewBottomAnchor_viewBottom_EXTRA?.isActive = false
        
        if show {
            mapViewTopAnchor_safeTop_EXTRA?.isActive = true
            mapViewBottomAnchor_viewBottom_EXTRA?.isActive = true
        } else {
            mapViewTopAnchor_safeTop?.isActive = true
            mapViewBottomAnchor_viewBottom?.isActive = true
        }
        
        UIView.animate(withDuration: 0.15,
                       animations: {self.view.layoutIfNeeded()},
                       completion: nil)

    }
}






