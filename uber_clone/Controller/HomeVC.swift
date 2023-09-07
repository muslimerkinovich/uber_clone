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
    
    private var mapView: MKMapView?
    
    //MARK: - Life Cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .backgroundColor
        checkIfUserIsLoggedIn()
        signOut()
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
        
        mapView = MKMapView()
        mapView?.frame = view.frame
        view.addSubview(mapView!)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
