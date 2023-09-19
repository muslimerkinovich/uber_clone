//
//  HomeVC.swift
//  uber_clone
//
//  Created by Muslim on 07/09/23.
//

import UIKit
import Firebase
import MapKit

private enum ActionButtonConfiguration {
    case showMenu
    case dismissActionView
    
    init() {
        self = .showMenu
    }
}

class HomeVC: UIViewController {

    
    //MARK: - UI Properties
    
    private let mapView = MKMapView()

    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let rideActionView = RideActionView()
    
    private var actionButtonConfig = ActionButtonConfiguration()
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(actionButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    
    private let locationManager = LocationManager.shared.locationManager

    private var user: User? {
        didSet {
            locationInputView.user = user
        }
    }
    
    private var searchResults: [MKPlacemark] = []
    private var route: MKRoute?
    
    //MARK: - Life Cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkIfUserIsLoggedIn()
        enableLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }


    //MARK: - Selectors
    
    @objc func actionButtonPressed() {
        
        switch actionButtonConfig {
        case .showMenu:
            print("DEBUG: Handle show menu...")
        case .dismissActionView:
            print("DEBUG: Handle dismiss action view...")
            
            UIView.animate(withDuration: 0.3) {
                self.inputActivationView.alpha = 1
                self.configureActionButton(config: .showMenu)
                self.removeAnnotationsAndOverlays()
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                self.configureRideActionView(shouldShow: false)
            }
        }
    }

    //MARK: - API
    
    private func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let vc = LoginVC()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            setupVC()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let vc = LoginVC()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } catch {
            print(error)
        }
    }
    
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: uid) { user in
            self.user = user
        }
    }
    
    func fetchDrivers() {
        
        guard let location = locationManager?.location else { return }
        Service.shared.fetchDrivers(location: location) { driver in
            
            guard let coordinate = driver.location?.coordinate else { return }
            
            let annotation = DriverAnnotation(coordinate: coordinate, uid: driver.uid)
            
            var driverIsVisible: Bool {
                return self.mapView.annotations.contains { annotation in
                    guard let annotation = annotation as? DriverAnnotation else { return false }
                    
                    if driver.uid == annotation.uid {
                        annotation.updateDriverPosition(withCoordinate: driver.location!.coordinate)
                        return true
                    }
                    return false
                }
            }
            
            if !driverIsVisible {
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    //MARK: - Helper functions
    
    func setupVC() {
        
        setupUI()
        fetchUserData()
        fetchDrivers()
        
    }
    
    func setupUI() {
        setupMapView()
        
        view.addSubview(actionButton)
        actionButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.leftAnchor,
                            topPadding: 0,
                            leftPadding: 20,
                            width: 32,
                            height: 32)
        
        view.addSubview(inputActivationView)
        inputActivationView.delegate = self
        inputActivationView.centerX(inView: view,
                                    top: actionButton.bottomAnchor,
                                    topPadding: 24)
        inputActivationView.setDimensions(width: view.frame.width - 60,
                                          height: 50)
        
        inputActivationView.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.inputActivationView.alpha = 1
        }
    }
    
    func setupMapView() {
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(LocationCell.self,
                           forCellReuseIdentifier: LocationCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.frame = CGRect(x: 0,
                                 y: view.frame.height,
                                 width: view.frame.width,
                                 height: view.frame.height - locationInputView.frame.height)

        UIView.animate(withDuration: 0.3, delay: 0.3) { [self] in
            tableView.frame = CGRect(x: 0,
                                     y: 200,
                                     width: view.frame.width,
                                     height: view.frame.height - 200)
        }
    }
    
    func setupLocationInputView() {
        locationInputView.delegate = self
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 width: view.frame.width,
                                 height: 200)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.inputActivationView.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        }
    }
    
    func configureRideActionView(shouldShow: Bool, destination: MKPlacemark? = nil) {
        
        if shouldShow {
            view.addSubview(rideActionView)
            rideActionView.delegate = self
            rideActionView.frame = CGRect(x: 0,
                                          y: view.frame.height,
                                          width: view.frame.width,
                                          height: 300)
            rideActionView.alpha = 0
            UIView.animate(withDuration: 0.3) { [self] in
                rideActionView.alpha = 1
                rideActionView.frame.origin.y = view.frame.height - 300
            }
            
            guard let destination else { return }
            rideActionView.destination = destination
        }
        else {
            UIView.animate(withDuration: 0.3) { [self] in
                rideActionView.alpha = 1
                rideActionView.frame.origin.y = view.frame.height
            } completion: { _ in
                self.rideActionView.removeFromSuperview()
            }
        }
        
        
        
        
    }
    
    fileprivate func configureActionButton(config: ActionButtonConfiguration) {
        
        switch config {
            
        case .showMenu:
            actionButton.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal),
                                  for: .normal)
            actionButtonConfig = .showMenu
        case .dismissActionView:
            actionButton.setImage(UIImage(named: "arrow_left_1")?.withRenderingMode(.alwaysOriginal),
                                  for: .normal)
            actionButtonConfig = .dismissActionView
        }
    }
    
    func dismissLocationSearchView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.frame = CGRect(x: 0,
                                          y: self.view.frame.height,
                                          width: self.view.frame.width,
                                          height: 0)
            self.locationInputView.alpha = 0
        }, completion: { finished in
            self.locationInputView.removeFromSuperview()
            self.tableView.removeFromSuperview()
            if let completion {
                completion(finished)
            }
        })
    }
    
    
}

//MARK: - Location Manager Delegate
extension HomeVC: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            print("DEBUG: notDetermined")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("DEBUG: restricted, denied")
        case .authorizedAlways:
            print("DEBUG: authorizedAlways")
        case .authorizedWhenInUse:
            print("DEBUG: authorizedWhenInUse")
            locationManager?.requestAlwaysAuthorization()
        default:
            print("DEBUG: default")
        }
    }
}

//MARK: - Map Helper Functions
private extension HomeVC {
    
    func searchBy(query: String, completion: @escaping ([MKPlacemark]) -> Void) {
        
        var results: [MKPlacemark] = []
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            
            guard let response, error == nil else {
                print("DEBUG: Failed searching with error:", error!)
                return
            }
            
            response.mapItems.forEach { item in
                results.append(item.placemark)
            }
            
            completion(results)
        }
    }
    
    func generateRoute(toDestination destination: MKMapItem) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        
        direction.calculate { response, error in
            
            guard let response, error == nil else {
                print("DEBUG: Failed generate route to destination with error: \(error!.localizedDescription)")
                return
            }
            self.route = response.routes[0]
            
            guard let polyline = self.route?.polyline else { return }
            self.mapView.addOverlay(polyline)
            self.mapView.setVisibleMapRect(polyline.boundingMapRect,
                                           edgePadding: UIEdgeInsets(top: 40,
                                                                     left: 40,
                                                                     bottom: 300,
                                                                     right: 40),
                                           animated: true)
        }
    }
    
    func removeAnnotationsAndOverlays() {
        self.mapView.annotations.forEach { annotation in
            if let annotation = annotation as? MKPointAnnotation {
                self.mapView.removeAnnotation(annotation)
            }
        }
        if mapView.overlays.count > 0 {
            mapView.removeOverlay(mapView.overlays[0])
        }
    }
}

//MARK: - MapView  Delegate
extension HomeVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? DriverAnnotation {
            
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: DriverAnnotation.identifier)
            view.image = UIImage(named: "chevron_right")
            
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let route = self.route {
            let polyline = route.polyline
            let lineRenderer = MKPolylineRenderer(overlay: polyline)
            lineRenderer.lineWidth = 3
            lineRenderer.strokeColor = .systemBlue
            
            return lineRenderer
        }
        
        return MKOverlayRenderer()
    }
}

//MARK: - Location Input Activation View
extension HomeVC: LocationInputActivationViewDelegate {
    
    func presentLocationInputView() {
        print("present Location Input View")
        setupTableView()
        setupLocationInputView()
    }
}

//MARK: - Location Input View
extension HomeVC: LocationInputViewDelegate {
    
    func executeSearch(query: String) {
        // search by query
        searchBy(query: query) { placemarks in
            self.view.endEditing(true)
            self.searchResults = placemarks
            self.tableView.reloadData()
        }
    }
    func dismissLocationInputView() {
        dismissLocationSearchView { _ in
            UIView.animate(withDuration: 0.6) {
                self.inputActivationView.alpha = 1
            }
        }
    }
}

//MARK: - TableView Delegates
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier) as! LocationCell
        
        switch indexPath.section {
        case 1:
            let item = searchResults[indexPath.row]
            
            cell.placemark = item
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ""
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : .greatestFiniteMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPlacemark = searchResults[indexPath.row]
        
        configureActionButton(config: .dismissActionView)
        
        let destination = MKMapItem(placemark: selectedPlacemark)
        generateRoute(toDestination: destination)
        
        dismissLocationSearchView { _ in
            let annotation = MKPointAnnotation()
            annotation.title = selectedPlacemark.name
//            annotation.subtitle = selectedPlacemark.address
            annotation.coordinate = selectedPlacemark.coordinate
            
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
            self.configureRideActionView(shouldShow: true, destination: selectedPlacemark)
//            let annotations = self.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self)})
//            self.mapView.showAnnotations(annotations, animated: true)
        }
    }
}

//MARK: - RideActionView Delegate
extension HomeVC: RideActionViewDelegate {
    
    func uploadTrip(_ view: RideActionView) {
        guard let pickupCoordinate = locationManager?.location?.coordinate else { return }
        guard let destinationCoordinate = view.destination?.coordinate else { return }
        
        Service.shared.uploadTrip(pickupCoordinate: pickupCoordinate,
                                  destinationCoordinate: destinationCoordinate) { error, ref in
            if let error {
                print("DEBUG: Error upload trip:", error)
            }
            
            print("DEBUG: Did upload trip successfully")
        }
    }
}
