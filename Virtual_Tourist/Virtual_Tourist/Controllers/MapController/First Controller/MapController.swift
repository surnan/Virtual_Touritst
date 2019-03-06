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

    
    //MARK:- UI Constraints - CONSTANTS
    let bottomUILabelHeight: CGFloat = 70
    let defaultTitleFontSize: CGFloat = 22
    let defaultFontSize: CGFloat = 18
    
    //MARK:- UI Constraints - DYNAMIC
    var anchorMapTop_SafeAreaTop: NSLayoutConstraint?
    var anchorMapTop_ShiftMapToShowDeletionLabel: NSLayoutConstraint?
    var anchorMapBottom_ViewBottom: NSLayoutConstraint?
    var anchorMapBottom_ShiftMapToShowDeletionLabel: NSLayoutConstraint?
    
    //MARK:- Var not used for Constraints
    
    var task: URLSessionTask?
    
    var tapDeletesPin = false
    var dataController: DataController!
    var myFetchController: NSFetchedResultsController<Pin>!
    var oldCoordinates: CLLocationCoordinate2D? //Updating Pin Entity after dragging
    var mapView = MKMapView()
    
    lazy private var myLongPressGesture: UILongPressGestureRecognizer = {
        var longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        longGesture.addTarget(self, action: #selector(handleLongPress(sender:)))
        return longGesture
    }()
    
    lazy var bottomUILabel: UILabel = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        mapView.delegate = self
        mapView.addGestureRecognizer(myLongPressGesture)
        setupUI()
        setupFetchController()
        myFetchController.delegate = self
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        getAllPins().forEach{
            placeAnnotation(pin: $0)
        }
    }
}
