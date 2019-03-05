//class MapController: UIViewController, NSFetchedResultsControllerDelegate {
//    
//    
//    var dataController: DataController!
//    var myFetchController: NSFetchedResultsController<Pin>!
//    
//    var selectedAnnotation: MKPointAnnotation?
//    var bootUP = true
//    
//    private let bottomUILabelHeight: CGFloat = 70
//    private let defaultTitleFontSize: CGFloat = 22
//    private let defaultFontSize: CGFloat = 18
//    
//    var mapViewTopAnchor_safeTop: NSLayoutConstraint?
//    var mapViewTopAnchor_safeTop_EXTRA: NSLayoutConstraint?
//    var mapViewBottomAnchor_viewBottom: NSLayoutConstraint?
//    var mapViewBottomAnchor_viewBottom_EXTRA: NSLayoutConstraint?
//    
//    //    var imageArray = [UIImage]()
//    var deletePhase = false
//    
//    
//    func setupFetchController(){
//        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
//        myFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                                       managedObjectContext: dataController.viewContext,
//                                                       sectionNameKeyPath: nil,
//                                                       cacheName: nil)
//        do {
//            try myFetchController.performFetch()
//        } catch {
//            fatalError("Unable to setup Fetch Controller: \n\(error)")
//        }
//    }
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.yellow
//        mapView.delegate = self
//        setupUI()
//        setupFetchController()
//        myFetchController.delegate = self
//        
//        
//        
//        guard let pins = myFetchController.fetchedObjects else {
//            self.bootUP = false
//            return
//        }
//        
//        pins.forEach{
//            let tempLocation = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
//            placeAnnotation(location: tempLocation)
//        }
//        
//        bootUP = false
//        
//        
//}
