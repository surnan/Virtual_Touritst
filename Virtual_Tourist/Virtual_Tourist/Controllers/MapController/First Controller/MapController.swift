//
//  ViewController.swift
//  Virtual_Tourist
//
//  Created by admin on 2/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class MapController: UIViewController, NSFetchedResultsControllerDelegate {
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Pin>!
    
    var selectedAnnotation: MKPointAnnotation?

    private let bottomUILabelHeight: CGFloat = 70
    private let defaultTitleFontSize: CGFloat = 22
    private let defaultFontSize: CGFloat = 18
    
    var mapViewTopAnchor_safeTop: NSLayoutConstraint?
    var mapViewTopAnchor_safeTop_EXTRA: NSLayoutConstraint?
    var mapViewBottomAnchor_viewBottom: NSLayoutConstraint?
    var mapViewBottomAnchor_viewBottom_EXTRA: NSLayoutConstraint?
    
    var deletePhase = false
    var bootUP = true
    
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(ResetBarButton))
        
        
    }
    
    
    @objc func ResetBarButton(){
        mapView.removeAnnotations(mapView.annotations)
        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        
        
        do {
            try dataController.viewContext.execute(request)
            try dataController.viewContext.save()
        } catch {
            print ("There was an error")
        }
        
        
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

    
    func setupFetchController(){
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        myFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext: dataController.viewContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        do {
            try myFetchController.performFetch()
        } catch {
            fatalError("Unable to setup Fetch Controller: \n\(error)")
        }
    }
    
    
    
    
    func getAllPins()->[Pin]{
        guard let pins = myFetchController.fetchedObjects else {
            self.bootUP = false
            return []
        }
        return pins
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        mapView.delegate = self
        setupUI()
        setupFetchController()
        myFetchController.delegate = self

        getAllPins().forEach{
            placeAnnotation(pin: $0)
        }
        bootUP = false
    }
    

    func placeAnnotation(pin: Pin?) {
        let newAnnotation = MKPointAnnotation()
        guard let lat = pin?.latitude, let lon = pin?.longitude else {return}
        newAnnotation.coordinate.latitude = lat
        newAnnotation.coordinate.longitude = lon
        
//        let latString = String(format: "%.1f", ceil(lat*100)/100)
//        let lonString = String(format: "%.1f", ceil(lon*100)/100)
        
//        newAnnotation.title =  "\(pin?.index ?? Int16(0)): \(latString) & \(lonString)"
//        newAnnotation.title =  "\(pin?.index ?? Int16(0))"
        mapView.addAnnotation(newAnnotation)
    }
}


/*
 override func viewDidLoad() {
 super.viewDidLoad()
 view.backgroundColor = UIColor.yellow
 mapView.delegate = self
 setupUI()
 setupFetchController()
 myFetchController.delegate = self
 
 getAllPins().forEach{
 let tempLocation = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
 placeAnnotation(location: tempLocation)
 }
 bootUP = false
 }
 
 func placeAnnotation(location: CLLocationCoordinate2D?){
 let annotation = MKPointAnnotation()
 if let coordinate = location {
 print("lat = \(coordinate.latitude)  ..... lon = \(coordinate.longitude)")
 annotation.coordinate = coordinate
 mapView.addAnnotation(annotation)
 } else {
 print("Unable to obtain coordinates")
 }
 }
 */




