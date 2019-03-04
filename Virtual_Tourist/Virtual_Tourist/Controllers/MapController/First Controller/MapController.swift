//
//  ViewController.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


var imageArray = [UIImage]()


class MapController: UIViewController {
    
    var dataController: DataController!
    
    var selectedAnnotation: MKPointAnnotation?

    private let bottomUILabelHeight: CGFloat = 70
    private let defaultTitleFontSize: CGFloat = 22
    private let defaultFontSize: CGFloat = 18
    
    var mapViewTopAnchor_safeTop: NSLayoutConstraint?
    var mapViewTopAnchor_safeTop_EXTRA: NSLayoutConstraint?
    var mapViewBottomAnchor_viewBottom: NSLayoutConstraint?
    var mapViewBottomAnchor_viewBottom_EXTRA: NSLayoutConstraint?
    
//    var imageArray = [UIImage]()
    var deletePhase = false
    
    lazy var mapView: MKMapView = {
       let view = MKMapView()
        view.addGestureRecognizer(myLongPressGesture)
        return view
    }()
    
    lazy private var myLongPressGesture: UILongPressGestureRecognizer = {
        var longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        longGesture.addTarget(self, action: #selector(handleLongPress(sender:)))
        return longGesture
    }()
    
    lazy private var bottomUILabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = UIColor.red
        let attributes: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: defaultTitleFontSize),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            ]
        label.attributedText = NSAttributedString(string: "Tap Pins to Delete", attributes: attributes)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: bottomUILabelHeight).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: defaultTitleFontSize)]
        navigationItem.title = "Virtual Tourist"
        let editDoneButton: UIButton = {
            let button = UIButton()
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setAttributedTitle(NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.font :  UIFont.systemFont(ofSize: defaultFontSize)]), for: .selected)
            button.setTitle("Done", for: .selected)
            button.addTarget(self, action: #selector(handleRightBarButton), for: .touchUpInside)
            button.isSelected = false
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        let customBarButton = UIBarButtonItem(customView: editDoneButton)
        self.navigationItem.setRightBarButton(customBarButton, animated: true)
    }
    
    @objc private func handleRightBarButton(sender: UIButton){
        sender.isSelected = !sender.isSelected
        toggleBottomUILabel(show: sender.isSelected)
    }
    
    private func setupUI(){
        setupNavigationBar()
        [mapView, bottomUILabel].forEach{view.addSubview($0)}
        mapView.anchor(top: nil, leading: bottomUILabel.leadingAnchor, trailing: bottomUILabel.trailingAnchor, bottom: nil)
        bottomUILabel.anchor(top: mapView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: nil)
        mapViewTopAnchor_safeTop =  mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        mapViewBottomAnchor_viewBottom =  mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        mapViewTopAnchor_safeTop_EXTRA = mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -bottomUILabelHeight)
        mapViewBottomAnchor_viewBottom_EXTRA = mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomUILabelHeight)
        hideBottomlabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        mapView.delegate = self
        setupUI()
    }
}






