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

let fetchCount = 21

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
    
    var previousPinID: NSManagedObjectID?   //original coordinate prior to move
    var saveObserverToken: Any?
    
    //MARK:- non-UI variables start here
    var task: URLSessionTask?
    var delegate: CollectionMapViewControllerDelegate?
    
    var tapDeletesPin = false   //determines if deletionLabel is shown in UI
    var dataController: DataController! //injected from AppDelegate
    var myFetchController: NSFetchedResultsController<Pin>!
    
    
    var mapView = MKMapView()
    var nextPage = false //Passed into Flickr.  False, retrieve url for pin.page.  True, retrieve url for pin.page+1
    
    lazy private var myLongPressGesture: UILongPressGestureRecognizer = {
        var longGesture = UILongPressGestureRecognizer()
        longGesture.minimumPressDuration = 1
        longGesture.addTarget(self, action: #selector(handleLongPress(sender:)))
        return longGesture
    }()
    
    lazy var deletionLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = UIColor.red
        let attributes: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: defaultTitleFontSize),
            NSAttributedString.Key.foregroundColor: UIColor.white]
        label.attributedText = NSAttributedString(string: "Tap Pins to Delete", attributes: attributes)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: bottomUILabelHeight).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow        
        
        self.addSaveNotifcationObserver()

        mapView.delegate = self
        mapView.addGestureRecognizer(myLongPressGesture)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        setupUI()
        setupFetchController()
        myFetchController.delegate = self
        getAllPins().forEach{
            placeAnnotation(pin: $0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        myFetchController = nil
    }
    
    
    deinit {
        removeSaveNotificationObserver()
    }
    
}
