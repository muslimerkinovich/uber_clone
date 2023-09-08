//
//  HomeVC.swift
//  uber_clone
//
//  Created by Muslim on 07/09/23.
//

import UIKit
import Firebase
import MapKit

class HomeVC: UIViewController {

    
    //MARK: - UI Properties
    
    private let mapView = MKMapView()

    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    //MARK: - Properties
    
    private let locationManager = CLLocationManager()
    
    private var user: User? {
        didSet {
            locationInputView.user = user
        }
    }
    //MARK: - Life Cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkIfUserIsLoggedIn()
        enableLocationServices()
        fetchUserData()
    }


    //MARK: - Selectors

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
            setupUI()
        }
    }
    
    func fetchUserData() {
        Service.shared.fetchUserData { user in
            self.user = user
        }
    }
    
    //MARK: - Setup functions
    func setupUI() {
        setupMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.delegate = self
        inputActivationView.setDimensions(widht: view.frame.width - 60,
                                          height: 50)
        inputActivationView.centerX(inView: view,
                                    top: view.safeAreaLayoutGuide.topAnchor,
                                    topPadding: 30)
        inputActivationView.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.inputActivationView.alpha = 1
        }
    }
    
    func setupMapView() {
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
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
            self.locationInputView.alpha = 1
        } completion: { _ in
            print("Present Location Input View finished")
        }

        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

extension HomeVC: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("DEBUG: notDetermined")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("DEBUG: restricted, denied")
        case .authorizedAlways:
            print("DEBUG: authorizedAlways")
        case .authorizedWhenInUse:
            print("DEBUG: authorizedWhenInUse")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            print("DEBUG: default")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestAlwaysAuthorization()
        }
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
    
    func dissmisLocationInputView() {
        
        UIView.animate(withDuration: 0.3) {
            
            self.tableView.frame = CGRect(x: 0,
                                          y: self.view.frame.height,
                                          width: self.view.frame.width,
                                          height: 0)
            self.locationInputView.alpha = 0
            self.inputActivationView.alpha = 1
        } completion: { _ in
            self.locationInputView.removeFromSuperview()
            self.tableView.removeFromSuperview()
        }
    }
}


//MARK: - TableView Delegates

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier) as! LocationCell
        
        cell.setupCell(title: "Location Name",
                       description: "Location Desciption")
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ""
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : .greatestFiniteMagnitude
    }
    
    
}
