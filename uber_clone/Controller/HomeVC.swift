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

    //MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    //MARK: - Life Cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkIfUserIsLoggedIn()
        enableLocationServices()
    }


    //MARK: - Selectors

    //MARK: - Functions
    
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
    
    func setupUI() {
        setupMapView()
    }
    
    func setupMapView() {
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
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
